require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Util do

  it "returns system ram in megabytes" do
    require 'ohai'
    ohai = Ohai::System.new
    ohai.require_plugin "linux::memory"
    total_ram = ohai["memory"]["total"]
    total_ram_m = JVMArgs::Util.convert_to_m(total_ram)
    JVMArgs::Util.get_system_ram_m.should == total_ram_m
  end
  
  it "converts lowercase m to uppercase M w/out changing the number" do
    JVMArgs::Util.convert_to_m("78m").should == "78M"
  end

  it "converts number kilobytes to megabytes" do
    JVMArgs::Util.convert_to_m("78000K").should == "76M"
  end

  it "converts gigabytes to kilobytes properly" do
    JVMArgs::Util.convert_to_m("78G").should == "79872M"
  end
  
end
