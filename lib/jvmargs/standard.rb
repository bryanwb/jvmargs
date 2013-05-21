module JVMArgs

  class Standard
    
    attr_accessor :key, :value
    
    def initialize(arg)
      stripped = arg.sub(/^-/, '')
      @key = stripped 
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
