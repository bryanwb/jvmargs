require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Unstable do

  it "parse option name and negative boolean" do
    arg = JVMArgs::Unstable.new("-XX:-DisableExplicitGC")
    arg.key.should == "DisableExplicitGC"
    arg.value.should == false
  end

   it "parse option name and positive boolean" do
    arg = JVMArgs::Unstable.new("-XX:+DisableExplicitGC")
    arg.key.should == "DisableExplicitGC"
    arg.value.should == true
  end

  it "returns option to proper string representation for boolean" do
    arg = JVMArgs::Unstable.new("-XX:-DisableExplicitGC")
    arg.to_s.should == "-XX:-DisableExplicitGC"
  end

  it "fills in missing initial dash" do
    arg = JVMArgs::Unstable.new("XX:-DisableExplicitGC")
    arg.to_s.should == "-XX:-DisableExplicitGC"
  end

  it "parse option name and non-boolean value" do
    arg = JVMArgs::Unstable.new("-XX:AltStackSize=16384")
    arg.key.should == "AltStackSize"
    arg.value.should == "16384"
  end

  it "should not modify its arguments" do
    initial_arg = "-XX:AltStackSize=16384"
    arg = JVMArgs::Unstable.new(initial_arg)

    initial_arg.should eq "-XX:AltStackSize=16384"
  end
end
