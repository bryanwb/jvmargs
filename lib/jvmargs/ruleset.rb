module JVMArgs
  class RuleSet

    def initialize()
      @rules = Array.new
      JVMArgs::Rules.singleton_methods(false).each do |m|
        @rules << m
      end
    end
    
    def add(rule)
      if rule.class != Proc
        raise ArgumentError, "The add method only accepts Proc objects as the second argument "
      end
      @rules ||= []
      @rules << rule
    end

    def each
      @rules.each {|rule| yield(rule) }
    end

    def [](index)
      @rules[index]
    end
    
  end
end
