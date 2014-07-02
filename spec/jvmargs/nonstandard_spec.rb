require 'jvmargs'
require 'spec_helper'

describe JVMArgs::NonStandard do

  it "parse option name and specified value" do
    arg = JVMArgs::NonStandard.new("-Xmx295M")
    expect(arg.key).to eq("Xmx")
    expect(arg.value).to eq("295M")
  end

  it "returns option to proper string representation" do
    arg = JVMArgs::NonStandard.new("-Xmx295M")
    expect(arg.to_s).to eq("-Xmx295M")
  end

  it "fills in missing initial dash" do
    arg = JVMArgs::NonStandard.new("Xmx295M")
    expect(arg.to_s).to eq("-Xmx295M")
  end

  it "handles boolean option" do
    arg = JVMArgs::NonStandard.new("-Xint")
    expect(arg.to_s).to eq("-Xint")
  end

  it "handles numeric value < 1MB" do
    arg = JVMArgs::NonStandard.new("-Xss122k")
    expect(arg.to_s).to eq("-Xss122K")
  end

  it "does not modify its arguments" do
    input_arg = '-Xmx100M'
    arg = JVMArgs::NonStandard.new(input_arg)

    expect(arg.to_s).to eq('-Xmx100M')
  end
  
  it "handles parameterised values" do
    arg = JVMArgs::NonStandard.new('-Xloggc:/var/log/gc.log')    
    expect(arg.to_s).to eq('-Xloggc:/var/log/gc.log')
  end
  
  it "parameterised arg should seperate on :" do
    arg = JVMArgs::NonStandard.new('-Xshare:auto')    
    expect(arg.key).to eq('Xshare:')
  end
  
end
