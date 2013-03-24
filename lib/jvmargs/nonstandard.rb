module JVMArgs
  class NonStandard
    attr_accessor :key, :value
    
    def initialize(arg)
      arg.sub!(/^-/, '')
      arg =~ /(X[a-z]+)([0-9]+[a-zA-Z])?/
      @key = $1
      if $2.nil?
        @value =  true
      else
        @value = JVMArgs::Util.convert_to_m($2)
      end
    end
    
    def to_s
      if @value == true
        "-#{@key}"
      else
        "-#{@key}#{@value}"
      end
    end
  end
end
