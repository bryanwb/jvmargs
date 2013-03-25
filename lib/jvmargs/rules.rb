module JVMArgs
  class Rules 

    def self.add(rule_name, block)
      JVMArgs::Rules.define_singleton_method(rule_name.to_sym) {|args| block.call(args) }
    end

    def self.rules
      JVMArgs::Rules.singleton_methods(false)
    end
    
    def self.[](index)
      @rules[index]
    end

    
    def self.heap_too_big(key="Xmx",args)
      total_ram = JVMArgs::Util.get_raw_num(JVMArgs::Util.get_system_ram_m)
      new_ram = JVMArgs::Util.get_raw_num(args[:nonstandard][key].value)
      if new_ram > total_ram
        raise ArgumentError, "You can't set #{key} to larger than the available system RAM of #{total_ram}"
      end
    end

    def self.max_smaller_than_min(key="Xmx",args)
      if args[:nonstandard]["Xms"].nil?
        return
      else
        max_heap = JVMArgs::Util.get_raw_num(args[:nonstandard]["Xmx"].value)
        min_heap = JVMArgs::Util.get_raw_num(args[:nonstandard]["Xms"].value)
        if max_heap < min_heap
          raise ArgumentError, "Max heap size #{max_heap}M cannot be smaller than Minimum heap size #{min_heap}M"
        end
      end
    end

  end
end

  # HeapRules = [
  #              method(:heap_too_big).to_proc,
  #              method(:max_smaller_than_min).to_proc
  #             ]

  
