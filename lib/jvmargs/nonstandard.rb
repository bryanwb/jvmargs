module JVMArgs
  class NonStandard
    attr_accessor :key, :value
    
    def initialize(arg)
      arg.sub!(/^-/, '')
      arg =~ /(X[a-z]+)([0-9]+[a-zA-Z])?/
      @key = $1
      @value = $2.nil? ? true : $2
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
