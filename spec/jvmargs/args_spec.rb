require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Args do

  it "provides default arguments" do
    args = JVMArgs::Args.new
    args_str = args.to_s
    args_str.should include "-server"
    args_str.should include "-Xmx"
  end

  it "provide jmx values if specified by block" do
    args = JVMArgs::Args.new(){ jmx true}
    args_str = args.to_s
    args_str.should include "-Djava.rmi.server.hostname=127.0.0.1"
    args_str.should include "-Dcom.sun.management.jmxremote"
    args_str.should include "-Dcom.sun.management.jmxremote.port=9000"
    args_str.should include "-Dcom.sun.management.jmxremote.authenticate=false"
    args_str.should include "-Dcom.sun.management.jmxremote.ssl=false"
  end

  it "set heap_size in MB" do
    size = "1234M"
    args = JVMArgs::Args.new { heap_size size }
    args_str = args.to_s
    args_str.should include "-Xms#{size}"
    args_str.should include "-Xmx#{size}"
  end
  
  it "set heap_size by a percentage" do
    args = JVMArgs::Args.new { heap_size "70%" }
    args_str = args.to_s
    percent_int = JVMArgs::Util.get_system_ram_m.sub(/M/,'').to_i
    percentage_ram = (percent_int * 0.7).to_i
    args_str.should include "-Xms#{percentage_ram}M"
    args_str.should include "-Xmx#{percentage_ram}M"
  end

  it "set permgen in MB" do
    size = "123M"
    args = JVMArgs::Args.new { permgen size }
    args_str = args.to_s
    args_str.should include "-XX:MaxPermSize=#{size}"
  end

  it "set newgen in MB" do
    size = "32M"
    args = JVMArgs::Args.new { newgen size }
    args_str = args.to_s
    args_str.should include "-XX:MaxNewSize=#{size}"
  end
  
  it "sets the max heap size to 40% of available RAM if not specified" do
    total_ram = JVMArgs::Util.get_system_ram_m
    heap_size = total_ram.to_i * 0.4
    args = JVMArgs::Args.new
    args.to_s.should include "-Xmx#{heap_size.to_i}M"
  end
  
  it "overwrites an existing argument w/ new value" do
    args = JVMArgs::Args.new("-Xmx295M", "Xms295M")
    args.to_s.should include "-Xmx295M"
    args[:nonstandard]["Xmx"].value.should == "295M"
    args[:nonstandard]["Xms"].value.should == "295M"
  end

  it "overwrites an existing argument w/ add method" do
    args = JVMArgs::Args.new("-Xmx295M")
    args.add("Xmx512M")
    args[:nonstandard]["Xmx"].value.should == "512M"
  end

  
  it "can handle a whole bunch for options" do
    args = JVMArgs::Args.new(
                             "-Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties",
                             "-XX:+DisableExplicitGC",
                             "-XX:+UseParallelOldGC",
                             "-XX:NewRatio=2",
                             "-XX:SoftRefLRUPolicyMSPerMB=36000",
                             "-Dsun.rmi.dgc.server.gcInterval=3600000",
                             "-XX:+UseBiasedLocking",
                             "-Xrs",
                             "-DSERVER_DATA_DIR=/data/Data/",
                             "-Xmx2560m",
                             "-Xms2560m",
                             "-XX:MaxPermSize=256M"
                             )
    target_list = [
                   "-Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties",
                   "-XX:+DisableExplicitGC",
                   "-XX:+UseParallelOldGC",
                   "-XX:NewRatio=2",
                   "-XX:SoftRefLRUPolicyMSPerMB=36000",
                   "-Dsun.rmi.dgc.server.gcInterval=3600000",
                   "-XX:+UseBiasedLocking",
                   "-Xrs",
                   "-DSERVER_DATA_DIR=/data/Data/",
                   "-Xmx2560M",
                   "-Xms2560M",
                   "-XX:MaxPermSize=256M",
                   "-server"
                  ]
    target_list.sort!
    sorted_args = args.to_s.split(" ").select {|arg| arg != " " }
    sorted_args.sort!
    sorted_args.should =~ target_list
  end

  it "won't let you set heap size greater than system ram" do
    lambda { JVMArgs::Args.new("-Xmx9999999999999K") }.should raise_error(ArgumentError)
  end

  it "won't let you set heap size greater than minimum heap size" do
    lambda { JVMArgs::Args.new("-Xmx99M", "-Xms200M") }.should raise_error(ArgumentError)
  end

  it "allows you to define a new rule" do
    args = JVMArgs::Args.new("-Xmx200M")
    args.add_rule(:equal_max_min_heap) do |args|
      args[:nonstandard]['Xms'] = JVMArgs::NonStandard.new("Xms128M")
      value = args[:nonstandard]['Xmx'].value
      args[:nonstandard]['Xms'].value = value
    end
    args_str = args.to_s
    args_str.should include "-Xms200M"
  end

  it "does not modify its arguments" do
    standard = '-jar foo.jar'
    nonstandard = '-Xmx100M'
    directive = '-Dsome.property=123'
    unstable = '-XX:NewRatio=2'

    args = JVMArgs::Args.new(standard, nonstandard, directive, unstable)

    standard.should eq '-jar foo.jar'
    nonstandard.should eq '-Xmx100M'
    directive.should eq '-Dsome.property=123'
    unstable.should eq '-XX:NewRatio=2'
  end
end

