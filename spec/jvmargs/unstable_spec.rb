require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Unstable do

  it "parse option name and negative boolean" do
    arg = JVMArgs::Unstable.new("-XX:-DisableExplicitGC")
    expect(arg.key).to eq("DisableExplicitGC")
    expect(arg.value).to eq(false)
  end

   it "parse option name and positive boolean" do
    arg = JVMArgs::Unstable.new("-XX:+DisableExplicitGC")
    expect(arg.key).to eq("DisableExplicitGC")
    expect(arg.value).to eq(true)
  end

  it "returns option to proper string representation for boolean" do
    arg = JVMArgs::Unstable.new("-XX:-DisableExplicitGC")
    expect(arg.to_s).to eq("-XX:-DisableExplicitGC")
  end

  it "fills in missing initial dash" do
    arg = JVMArgs::Unstable.new("XX:-DisableExplicitGC")
    expect(arg.to_s).to eq("-XX:-DisableExplicitGC")
  end

  it "parse option name and non-boolean value" do
    arg = JVMArgs::Unstable.new("-XX:AltStackSize=16384")
    expect(arg.key).to eq("AltStackSize")
    expect(arg.value).to eq("16384")
  end

  it "should not modify its arguments" do
    initial_arg = "-XX:AltStackSize=16384"
    arg = JVMArgs::Unstable.new(initial_arg)

    expect(initial_arg).to eq "-XX:AltStackSize=16384"
  end

  it "should parse paths with '-' in them" do
    arg = JVMArgs::Unstable.new("-XX:ErrorPath=/var/thing-that/foo-bar")
    expect(arg.key).to eq("ErrorPath")
    expect(arg.value).to eq("/var/thing-that/foo-bar")
  end
end
