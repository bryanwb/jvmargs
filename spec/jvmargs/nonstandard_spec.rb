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

  it "handles numeric value < 1MB" do
    arg = JVMArgs::NonStandard.new("-Xss122k")
    arg.to_s.should == "-Xss122K"
  end

  it "does not modify its arguments" do
    input_arg = '-Xmx100M'
    arg = JVMArgs::NonStandard.new(input_arg)

    arg.to_s.should == '-Xmx100M'
  end
  
  it "handles parameterised values" do
    arg = JVMArgs::NonStandard.new('-Xloggc:/var/log/gc.log')    
    arg.to_s.should == '-Xloggc:/var/log/gc.log'
  end
end
