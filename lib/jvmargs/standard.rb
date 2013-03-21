module JVMArgs

  class Standard
    
    attr_accessor :key, :value
    
    def initialize(arg)
      arg.sub!(/^-/, '')
      @key = arg
      @value = true
    end
       
    def to_s
      if @value
        "-#{@key}"
      else
        ""
      end
    end
  end

end
