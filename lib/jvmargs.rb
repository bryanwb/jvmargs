module JVMArgs

  class Directive

    def initialize(arg)
      arg.sub!(/^-?D?/, '')
    
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

    def key
      @key
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
    
    def initialize(initial_args=[],*named_args)
      @args = Hash.new()
      server_arg = JVMArgs::Standard.new("-server")
      @args[server_arg.key] = server_arg
      @args['Xmx'] = JVMArgs::NonStandard.new("Xmx128M")
      @args['Xms'] = JVMArgs::NonStandard.new("Xms128M")

      if initial_args.class == Hash and named_args.empty?
        parse_named_args(initial_args)
      elsif !named_args.empty?
        parse_named_args(named_args)
      end
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
  
