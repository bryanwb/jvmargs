require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Util do
  
  it "returns system ram in megabytes" do
    require 'ohai'
    ohai = Ohai::System.new
    ohai.require_plugin "linux::memory"
    total_ram = ohai["memory"]["total"]
    total_ram_m = JVMArgs::Util.convert_to_m(total_ram)
    expect(JVMArgs::Util.get_system_ram_m).to eq(total_ram_m)
  end
  
  it "converts lowercase m to uppercase M w/out changing the number" do
    expect(JVMArgs::Util.convert_to_m("78m")).to eq("78M")
  end

  it "converts number kilobytes to megabytes" do
    expect(JVMArgs::Util.convert_to_m("78000K")).to eq("76M")
  end

  it "converts gigabytes to kilobytes properly" do
    expect(JVMArgs::Util.convert_to_m("78G")).to eq("79872M")
  end
  
  describe "parse_ram_size_to_m" do
    it "parses memory sizes" do
      expect(JVMArgs::Util.parse_ram_size_to_m("73m")).to eq("73M")
      expect(JVMArgs::Util.parse_ram_size_to_m("1G")).to eq("1024M")
    end
    it "parses percentage" do
      expect(JVMArgs::Util.parse_ram_size_to_m("100%")).to eq(JVMArgs::Util.get_system_ram_m)
    end
  end
end
