require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Standard do

  it "should remove the leading dash" do
    arg = JVMArgs::Standard.new('-server')
    expect(arg.key).to eq("server")
  end

  it "returns server to -server" do
    arg = JVMArgs::Standard.new('-server')
    expect(arg.to_s).to eq("-server")
  end

  it "should not modify its arguments" do
    inputArg = '-jar foo.jar'
    arg = JVMArgs::Standard.new(inputArg)

    expect(inputArg).to eq '-jar foo.jar'
  end
end
