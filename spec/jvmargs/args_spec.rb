require 'jvmargs'
require 'spec_helper'

describe JVMArgs::Args do

  it "provides default arguments" do
    args = JVMArgs::Args.new
    args_str = args.to_s
    args_str.should include "-server"
    args_str.should include "-Xmx"
    args_str.should include "-Xms"
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
    total_ram = get_total_ram_kb
    heap_size = total_ram.to_i * 0.4
    args = JVMArgs::Args.new
    args.to_s.should include "-Xmx#{heap_size.to_i}K"
  end
  
  it "overwrites an existing argument w/ new value" do
    args = JVMArgs::Args.new("-Xmx295M", "Xms295M")
    args.to_s.should include "-Xmx295M"
    args[:nonstandard]["Xmx"].value.should == "295M"
    args[:nonstandard]["Xms"].value.should == "295M"
  end

  
end


# /usr/local/jvm/default/bin/java -Djava.util.logging.config.file=/usr/local/tomcat/geo2/conf/logging.properties -server -Djava.awt.headless=true -XX:+DisableExplicitGC -XX:+UseParallelOldGC -XX:NewRatio=2 -XX:SoftRefLRUPolicyMSPerMB=36000 -Dsun.rmi.dgc.server.gcInterval=3600000 -XX:+UseBiasedLocking -Xrs -DGEOSERVER_DATA_DIR=/data/geoData/ -Xmx2560m -Xms2560m -XX:MaxPermSize=256m -DGEOSERVER_LOG_LOCATION=/usr/local/tomcat/geo2/logs/geoServer2.log -DENABLE_JSONP=true -Djava.rmi.server.hostname=127.0.0.1 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9000 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1045 -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.endorsed.dirs=/usr/local/tomcat/default/endorsed -classpath /usr/local/tomcat/default/bin/tomcat-juli.jar:/usr/local/tomcat/default/bin/bootstrap.jar -Dcatalina.base=/usr/local/tomcat/geo2 -Dcatalina.home=/usr/local/tomcat/default -Djava.io.tmpdir=/usr/local/tomcat/geo2/temp org.apache.catalina.startup.Bootstrap  start
