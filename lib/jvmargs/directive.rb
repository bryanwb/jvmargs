module JVMArgs

  class Directive

    attr_accessor :key, :value

    def initialize(arg)
      arg.sub!(/^-?D?/, '')
    
      if arg =~ /(.*?)=(.*)/
        @key = $1
        @value = $2
      else
        @key = arg
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
