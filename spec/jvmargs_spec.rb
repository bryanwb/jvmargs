require 'jvmargs'

describe JVMArgs::Args do

  it "provides default arguments" do
    args = JVMArgs::Args.new
    args.to_s.should == " -server -Xmx128M -Xms128M "
  end

  it "provide jmx values if specified" do
    args = JVMArgs::Args.new({:jmx => true})
    args_str = args.to_s
    args_str.should include "-Djava.rmi.server.hostname=127.0.0.1"
    args_str.should include "-Dcom.sun.management.jmxremote"
    args_str.should include "-Dcom.sun.management.jmxremote.port=9000"
    args_str.should include "-Dcom.sun.management.jmxremote.authenticate=false"
    args_str.should include "-Dcom.sun.management.jmxremote.ssl=false"
  end

  it "sets the max heap size to 40% of available RAM if not specified" do
    require 'ohai'
    ohai = Ohai::Systen.new
    ohai.require_plugin "linux::memory"
    ram = ohai["memory"]["total"]
  end
  
  it "overwrites an existing argument w/ new value" do
    pending
  end

end

# " -Xmx512M -Xms512M -XX:MaxPermSize=256m -server -Djava.rmi.server.hostname=127.0.0.1 \
# -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9000 \
# -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false "
