require 'jvmargs'
require 'spec_helper'

describe JVMArgs::NonStandard do

  it "parse option name and specified value" do
    arg = JVMArgs::NonStandard.new("-Xmx295M")
    arg.key.should == "Xmx"
    arg.value.should == "295M"
  end

  it "returns option to proper string representation" do
    arg = JVMArgs::NonStandard.new("-Xmx295M")
    arg.to_s.should == "-Xmx295M"
  end

  it "fills in missing initial dash" do
    arg = JVMArgs::NonStandard.new("Xmx295M")
    arg.to_s.should == "-Xmx295M"
  end

  it "handles boolean option" do
    arg = JVMArgs::NonStandard.new("-Xint")
    arg.to_s.should == "-Xint"
  end
  
end
