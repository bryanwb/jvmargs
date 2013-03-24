require 'jvmargs'
require 'spec_helper'

describe JVMArgs::RuleSet do

  it "raises error when non-proc submitted as rule" do
    rules = JVMArgs::RuleSet.new
    lambda { rules.add('foo')}.should raise_error(ArgumentError)
  end

end
