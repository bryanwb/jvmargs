jvmargs
=======

A painless parser of java command-line arguments

Managing Java command-line arguments is a pain in the ass. I have
felt this pain in the many, many chef cookbooks I have written for
java applications.

This is currently chef-specific but I would love to see it support
Puppet as well.

I hope this helps stop some of the relentless cargo-culting of Java
command-line arguments.

Features
--------

* Raises an error if you try to allocate a larger heap
  size than your system has available.
* Allocates 40% of available RAM for the jvm heap if not specified
* Ensures that there are no duplicate arguments. A duplicate of an
  existing entry overwrites the existing one. For example, let's say
  we add  "-Xmx128M" to the list of jvmargs but "-Xmx256M" is already
  present. "-Xmx128M" will overwrite the previous "-Xmx256M". 
* Allows the quick and easy population of certain arguments per conventions
* TODO: Ensures that Maximum and Minimum heap size are always equal, because
  they should be.
* Inserts a space at the beginning and end of the returned string


Examples
--------

Here is the simplest possible use. Notice that max heap size and
minimum heap size are set to the same value and jvmargs assumes that
you want to use 40% of available RAM for the heap. Note that you
_must_ call the `.to_s` method to convert the JVMArgs object to a string

```Ruby
require 'jvmargs'
java_opts = JVMArgs::Args.new
# the value of java_opts.to_s is
# " -Xmx128m -Xms128m -server "
java_command = "/usr/bin/java #{java_opts.to_s} your_app.jar start"
```

Let's ask for a specific heap size and the default JMX setup, which is
tuned for gathering metrics using the awesome collectd:GenericJMX
plugin locally.

```Ruby
require 'jvmargs'
java_opts = JVMArgs::Args.new("-Xmx512M", "-XX:MaxPermSize=256m", {:jmx => true}) 
# the value of java_opts.to_s is
# " -Xmx512M -Xms512M -XX:MaxPermSize=256m -server -Djava.rmi.server.hostname=127.0.0.1 \
# -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9000 \
# -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false "
```

After creating the initial JVMArgs object you can add additional
arguments. If the same argument already exists, it will be overwritten
by the new argument. You might do this in Chef cookbook that sets up
defaults for a java application but then takes new settings from node
attributes or in arguments to an LWRP.

```Ruby
require 'jvmargs'
java_opts = JVMArgs::Args.new("-Xmx512M", "-XX:MaxPermSize=256m", {:jmx =>
true}) 
# node['tomcat']['max_heap_size'] is "-Xmx2048M"
java_opts.store(node['tomcat']['max_heap_size'])
# the -Xmx and -Xms arguments are now "-Xmx2048M" and "-Xms2048M"
```

There are a couple friendly helper functions

```Ruby
require 'jvmargs'
java_opts = JVMArgs::Args.new("-Xmx512M", "-XX:MaxPermSize=256m", {:jmx =>
true}) 
java_opts.heap_size("2048M")
java_opts.permgen("256M")
# the -Xmx and -Xms arguments are now "-Xmx2048M" and "-Xms2048M"
# permgen is now "-XX:MaxPermSize=256M"
```

## License and Author

- Author::                Bryan W. Berry (<bryan.berry@gmail.com>)
- Copyright::             2013, Bryan W. Berry


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
