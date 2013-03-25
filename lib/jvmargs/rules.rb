module JVMArgs
  class Rules 

    def initialize(*args)
      @rules = []
    end

    def each
      @rules.each do |rule|
        yield(rule)
      end
    end
    
    def add(rule_name, block)
      new_rule_name = "rule_#{rule_name.to_s}".to_sym
      self.class.send(:define_method, new_rule_name) {|args| block.call(args) }
    end

    def rules
      JVMArgs::Rules.public_instance_methods(false).select {|rule| rule.to_s =~ /^rule_.*/  }
    end
    
    def [](index)
      @rules[index]
    end

    
    def rule_heap_too_big(key="Xmx",args)
      total_ram = JVMArgs::Util.get_raw_num(JVMArgs::Util.get_system_ram_m)
      new_ram = JVMArgs::Util.get_raw_num(args[:nonstandard][key].value)
      if new_ram > total_ram
        raise ArgumentError, "You can't set #{key} to larger than the available system RAM of #{total_ram}"
      end
    end

    def rule_max_smaller_than_min(key="Xmx",args)
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

  
