module JVMArgs

  class Directive

    attr_accessor :key, :value

    def initialize(arg)
      stripped = arg.sub(/^-?D?/, '')
    
      if stripped =~ /(.*?)=(.*)/
        @key = $1
        @value = $2
      else
        @key = stripped
        @value = true
      end
    end

    def to_s
      if @value == true
        "-D#{@key}"
      else
        "-D#{@key}=#{@value}"
      end
    end
   
  end

end
