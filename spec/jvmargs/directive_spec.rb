require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Directive do

  it "drops dash and D from key name" do
    arg = JVMArgs::Directive.new("-Dcom.sun.management.jmxremote")
    expect(arg.key).to eq("com.sun.management.jmxremote")
  end
  
  it "parses boolean option" do
    arg = JVMArgs::Directive.new("-Dcom.sun.management.jmxremote")
    expect(arg.value).to eq(true)
  end
  
  it "parse option name and non-boolean value" do
    arg = JVMArgs::Directive.new("-Djava.util.logging.config.file=/foo/conf/logging.properties")
    expect(arg.key).to eq("java.util.logging.config.file")
    expect(arg.value).to eq("/foo/conf/logging.properties")
  end

  it "returns proper string representation for boolean" do
    arg = JVMArgs::Directive.new("-Dcom.sun.management.jmxremote")
    expect(arg.to_s).to eq("-Dcom.sun.management.jmxremote")
  end

  it "returns option to proper string representation for non-boolean" do
    arg = JVMArgs::Directive.new("-Djava.util.logging.config.file=/foo/conf/logging.properties")
    expect(arg.to_s).to eq("-Djava.util.logging.config.file=/foo/conf/logging.properties")
  end

  it "does not modify its arguments" do
    initial_arg = '-Dsome.property=foo'
    arg = JVMArgs::Directive.new(initial_arg)

    expect(initial_arg).to eq '-Dsome.property=foo'
  end
end


