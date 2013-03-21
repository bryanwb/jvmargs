require 'jvmargs'
require 'spec_helper'

describe JVMArgs::RuleSet do

  it "raises error when non-proc submitted as rule" do
    rules = JVMArgs::RuleSet.new
    lambda { rules.add('Xmx', 'foo')}.should raise_error(ArgumentError)
  end

  it "adds proc to list of rules for a key" do
    rules = JVMArgs::RuleSet.new
    p = Proc.new { puts 'hello world' }
    rules.add('Xmx', p)
    rules['Xmx'].send("[]".to_sym,0).class.should == Proc
  end

end
