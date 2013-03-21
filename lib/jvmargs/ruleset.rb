module JVMArgs
  class RuleSet

    def initialize()
      @rules = Hash.new
      @rules['Xmx'] = JVMArgs::HeapRules
    end
    
    def add(key, rule)
      if rule.class != Proc
        raise ArgumentError, "The add method only accepts Proc objects as the second argument "
      end
      @rules[key] ||= []
      @rules[key] << rule
    end

    def keys
      @rules.keys
    end

    def [](key)
      @rules[key]
    end

  end
end
