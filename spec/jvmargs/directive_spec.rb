require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Directive do

  it "drops dash and D from key name" do
    arg = JVMArgs::Directive.new("-Dcom.sun.management.jmxremote")
    arg.key.should == "com.sun.management.jmxremote"
  end
  
  it "parses boolean option" do
    arg = JVMArgs::Directive.new("-Dcom.sun.management.jmxremote")
    arg.value.should == true
  end
  
  it "parse option name and non-boolean value" do
    arg = JVMArgs::Directive.new("-Djava.util.logging.config.file=/foo/conf/logging.properties")
    arg.key.should == "java.util.logging.config.file"
    arg.value.should == "/foo/conf/logging.properties"
  end

  it "returns proper string representation for boolean" do
    arg = JVMArgs::Directive.new("-Dcom.sun.management.jmxremote")
    arg.to_s.should == "-Dcom.sun.management.jmxremote"
  end

  it "returns option to proper string representation for non-boolean" do
    arg = JVMArgs::Directive.new("-Djava.util.logging.config.file=/foo/conf/logging.properties")
    arg.to_s.should == "-Djava.util.logging.config.file=/foo/conf/logging.properties"
  end

  it "does not modify its arguments" do
    initial_arg = '-Dsome.property=foo'
    arg = JVMArgs::Directive.new(initial_arg)

    initial_arg.should eq '-Dsome.property=foo'
  end
end


