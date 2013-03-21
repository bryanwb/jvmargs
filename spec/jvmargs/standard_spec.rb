require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Standard do

  it "should remove the leading dash" do
    arg = JVMArgs::Standard.new('-server')
    arg.key.should == "server"
  end

  it "returns server to -server" do
    arg = JVMArgs::Standard.new('-server')
    arg.to_s.should == "-server"
  end
  
end
