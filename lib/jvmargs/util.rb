module JVMArgs
  module Util


    def self.get_system_ram_m
      if defined? node
        total_ram = node['memory']['total']
      else
        require 'ohai'
        ohai = Ohai::System.new
        begin
          ohai.all_plugins "memory"
        rescue ArgumentError
          ohai.require_plugin "linux::memory"
        end
        total_ram = ohai["memory"]["total"]
      end
      self.convert_to_m(total_ram)
    end

    def self.get_raw_num(number)
      number.sub(/M/, '').to_i
    end
    
    def self.convert_to_m(number)
      raw_num, unit = self.normalize_units(number)
      case unit
      when "K"
        converted_num = (raw_num/1024).to_int
      when "G"
        converted_num = (raw_num * 1024).to_int
      when "M"
        converted_num = raw_num
      end
      "#{converted_num}M"
    end
      
    def self.normalize_units(number)
      number =~ /^([0-9]+)\s*([kKmMgG])[bB]?/
      if $2.nil?
        raise ArgumentError, "You must indicate whether number is KiloBytes(K), MegaBytes (M), or Gigabytes(G)"
      end
      [$1.to_i, $2.upcase]
    end
    
    # Accepts a 'size' value such as 70% or 5G and converts this to
    # the size in M.
    def self.parse_ram_size_to_m(size)
      if (size =~ /([0-9]+)%/)
        percent = $1.to_i * 0.01
        if percent > 1
          raise ArgumentError, "heap_size percentage must be less than 100%, you provided #{$1}%"
        elsif percent < 0.01
          raise ArgumentError, "heap_size percentage must be between 100% - 1%, you provided #{$1}%"
        end
        system_ram = JVMArgs::Util.get_system_ram_m.sub(/M/,'').to_i
        size_ram = "#{(system_ram * percent).to_i}M"
      else
        begin
          size_ram = JVMArgs::Util.convert_to_m(size)
        rescue ArgumentError
           raise ArgumentError, "heap_size percentage must be a percentage or a fixed size in KiloBytes(K), MegaBytes (M), or Gigabytes(G)"
        end 
      end      
    end
  end
end
