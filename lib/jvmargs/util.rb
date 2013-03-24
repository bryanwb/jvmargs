module JVMArgs
  module Util


    def self.get_system_ram_k
      if defined? node
        total_ram = node['memory']['total']
      else
        require 'ohai'
        ohai = Ohai::System.new
        ohai.require_plugin "linux::memory"
        total_ram = ohai["memory"]["total"]
      end
      total_ram = (total_ram.sub(/kB/,'').to_i * 0.4).to_i
    end

    def self.convert_to_k(number)
      normalized_number = self.normalize_for_ruby_units(number)
      number_in_kb = self.convert_ruby_units(normalized_number)
      self.denormalize_from_ruby_units(number_in_kb)
    end

    def self.convert_ruby_units(normalized_number)
      require 'ruby-units'
      normalized_number = normalized_number.to_unit("kB")
    end
      
    def self.normalize_for_ruby_units(number)
      number =~ /^([0-9]+)\s*([kKmMgG])[bB]?/
      require 'pry' ; binding.pry
      "#{$1} #{$2.downcase}B"
    end

    def self.denormalize_from_ruby_units(number)
      number =~ /^([0-9]+)\s([kKmMgG])[bB]?/
      require 'pry' ; binding.pry
      
      "#{$1}#{$2.upcase}"
    end
    
  end
end
