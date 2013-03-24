module JVMArgs
  module Util


    def self.get_system_ram_m
      if defined? node
        total_ram = node['memory']['total']
      else
        require 'ohai'
        ohai = Ohai::System.new
        ohai.require_plugin "linux::memory"
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
    
  end
end
