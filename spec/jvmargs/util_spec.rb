require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Util do

  it "normalize for ruby-units library format" do
    JVMArgs::Util.normalize_for_ruby_units("78gb").should == "78 gB"
    JVMArgs::Util.normalize_for_ruby_units("78G").should == "78 gB"
    JVMArgs::Util.normalize_for_ruby_units("78m").should == "78 mB"
    JVMArgs::Util.normalize_for_ruby_units("78kB").should == "78 kB"
    JVMArgs::Util.normalize_for_ruby_units("78mb").should == "78 mB"
  end

  it "denormalize from ruby-units format to JVM command format" do
    JVMArgs::Util.denormalize_from_ruby_units("78 gB").should == "78G"
    JVMArgs::Util.denormalize_from_ruby_units("78 kB").should == "78K"
    JVMArgs::Util.denormalize_from_ruby_units("78 mB").should == "78M"
  end
  
  it "converts number Megabytes to kilobytes" do
    JVMArgs::Util.convert_to_k("78M").should == "79872K"
  end

  it "converts lowercase k to uppercase K w/out changing the number" do
    JVMArgs::Util.convert_to_k("78k").should == "78K"
  end

  it "converts number Megabytes to kilobytes" do
    JVMArgs::Util.convert_to_k("78k").should == "78K"
  end

  it "converts gigabytes to kilobytes properly" do
    JVMArgs::Util.convert_to_k("78G").should == "81788928K"
  end

  
end
