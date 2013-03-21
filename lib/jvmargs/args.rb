module JVMArgs
  class Args
    
    def initialize(*initial_args)
      @args = Hash.new
      JVMArgs::Types.each {|type| @args[type] = {} }
      server_arg = JVMArgs::Standard.new("-server")
      @args[:standard][server_arg.key] = server_arg
      set_default_heap_size
      initial_args.flatten!
      parse_initial_args(initial_args)
    end

    def parse_initial_args(initial_args)
        if !initial_args.empty?
        if initial_args[-1].class == Hash
          parse_named_args(initial_args[-1])
          if initial_args.length >= 2
            parse_args([0..-2])
          end
        else
          parse_args(initial_args)
        end
      end
    end
    
    def parse_args(args)
      args.each do |arg|
        type = nil
        jvm_arg = case arg
                  when /^-?XX.*/
                    type = :unstable
                    JVMArgs::NonStandard.new(arg)
                  when /^-?X.*/
                    type = :nonstandard
                    JVMArgs::NonStandard.new(arg)
                  when /^-?D.*/
                    type = :directive
                    JVMArgs::Directive.new(arg)
                  else
                    type = :standard
                    JVMArgs::Standard.new(arg)
                  end
        @args[:type][jvm_arg.key] = jvm_arg
      end
    end

    def set_default_heap_size
      if defined? node
        total_ram = node['memory']['total'].sub(/kB/, '')
      else
        require 'ohai'
        ohai = Ohai::System.new
        ohai.require_plugin "linux::memory"
        total_ram = (ohai["memory"]["total"].sub(/kB/,'').to_i * 0.4).to_i
      end
      @args[:nonstandard]['Xmx'] = JVMArgs::NonStandard.new("Xmx#{total_ram}K")
      @args[:nonstandard]['Xms'] = JVMArgs::NonStandard.new("Xms#{total_ram}K")
    end
    
    def to_s
      args_str = ""
      JVMARGS::Types.each do |type|
        type_str = @args[type].map {|k,v| v.to_s }
        args_str << " " + type_str.join(' ') + " "
      end
      args_str
    end

    def parse_named_args(named_args)
      named_args.each do |k,v|
        case k.to_sym
        when :jmx
          add_default_jmx
        end
      end
    end

    def add_default_jmx
      [
       "-Djava.rmi.server.hostname=127.0.0.1",
       "-Dcom.sun.management.jmxremote",
       "-Dcom.sun.management.jmxremote",
       "-Dcom.sun.management.jmxremote.port=9000",
       "-Dcom.sun.management.jmxremote.authenticate=false",
       "-Dcom.sun.management.jmxremote.ssl=false"
      ].each do |arg|
        directive = JVMArgs::Directive.new arg
        @args[:directive][directive.key] = directive
      end
    end
  end
end
