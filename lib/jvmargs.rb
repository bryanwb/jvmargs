module JVMArgs

  class Directive

    attr_accessor :key, :value

    def initialize(arg)
      arg.sub!(/^-?/, '')
    
      if arg =~ /(.*?)=(.*)/
        @key = $1
        @value = $2
      else
        @key = arg
        @value = true
      end
    end

    def to_s
      if @value == true
        "-D#{@key}"
      else
        "-D#{@key}=#{@value}"
      end
    end

   
  end

  class Standard
    
    attr_accessor :key, :value
    
    def initialize(arg)
      arg.sub!(/^-/, '')
      @key = arg
      @value = true
    end
       
    def to_s
      if @value
        "-#{@key}"
      else
        ""
      end
    end
  end

  #   when /(.*?):(\+|-)(.*)/
    
  class NonStandard
     attr_accessor :key, :value
    
    def initialize(arg)
      arg.sub!(/^-/, '')
      arg =~ /(X[a-z]+)([0-9]+[a-zA-Z])?/
      @key = $1
      @value = $2.nil? ? true : $2
    end
    
    def to_s
      if @value == true
        "-#{@key}"
      else
        "-#{@key}#{@value}"
      end
    end
  end
  
  class Args
    
    def initialize(*initial_args)
      @args = Hash.new()
      server_arg = JVMArgs::Standard.new("-server")
      @args[server_arg.key] = server_arg
      set_default_heap_size

      initial_args.flatten!
      
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

    def [](key)
      @args[key]
    end
    
    def parse_args(args)
      args.each do |arg|
        jvm_arg = case arg
                  when /^-?XX.*/
                    JVMArgs::NonStandard.new(arg)
                  when /^-?X.*/
                    JVMArgs::NonStandard.new(arg)
                  when /^-?D.*/
                    JVMArgs::Directive.new(arg)
                  else
                    JVMArgs::Standard.new(arg)
                  end
        @args[jvm_arg.key] = jvm_arg
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
      @args['Xmx'] = JVMArgs::NonStandard.new("Xmx#{total_ram}K")
      @args['Xms'] = JVMArgs::NonStandard.new("Xms#{total_ram}K")
    end
    
    def to_s
      args_str = @args.map {|k,v| v.to_s }
      " " + args_str.join(' ') + " "
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
        @args[directive.key] = directive
      end
    end

  end

end
  
