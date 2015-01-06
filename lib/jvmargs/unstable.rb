module JVMArgs
  class Unstable

   attr_accessor :key, :value
    
    def initialize(arg)
      stripped = arg.sub(/^-?XX:/, '')
      # check it if a boolean option
      stripped =~ /^(\+|-)(.*)$/
      if !$1.nil?
        @key = $2
        @value = $1 == '+' ? true : false
      else
        stripped =~ /(.*)=(.*)/
        @key = $1
        @value = $2
      end
    end
    
    def to_s
      if @value.class == TrueClass or @value.class == FalseClass
        symbol = @value ? '+' : '-'
        "-XX:#{symbol}#{@key}"
      else
        "-XX:#{@key}=#{@value}"
      end
    end
  end 
    
end
