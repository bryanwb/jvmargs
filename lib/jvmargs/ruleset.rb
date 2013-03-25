module JVMArgs
  class RuleSet
    
    def initialize()
      JVMArgs::Rules.singleton_methods(false).each do |m|
        rules << m
      end
    end
    
    def add(rule_name, block)
      JVMArgs::Rules.define_singleton_method(rule_name.to_sym) {|args| block.call(args) }
    end

    def rules
      JVMArgs::Rules.singleton_methods(false)
    end
    
    def [](index)
      @rules[index]
    end
    
  end
end
