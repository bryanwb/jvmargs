module JVMArgs

  def self.heap_too_big(key,args)
    total_ram = JVMArgs::Util.get_system_ram_k
    new_ram = args[:nonstandard][key].value.sub(/[Kk]/, '').to_i
    if new_ram > total_ram
      raise ArgumentError, "You can't set #{key} to larger than the available system RAM of #{total_ram}"
    end
  end

  HeapRules = [
               method(:heap_too_big).to_proc
              ]

  # def max_smaller_than_min(key)
  # end
  
end
