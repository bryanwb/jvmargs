lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'jvmargs/version'

Gem::Specification.new do |s|
  s.name = 'jvmargs'
  s.version = JVMArgs::VERSION
  s.description = 'Sanity check command-line arguments to the JVM'
  s.summary = "jvmargs-#{s.version}"
  s.authors = ['Bryan W. Berry', 'Thom May']
  s.homepage = 'https://github.com/bryanwb/jvmargs'
  s.license = 'Apache2'
  s.require_path = 'lib'
  s.files = Dir['lib/**/*.rb']
  
  s.add_dependency('chef', '>= 10.0')
  s.add_development_dependency('rspec', '~> 3.0.0')
  s.add_development_dependency('rake', '~> 0.9.2.2')
  s.add_development_dependency('pry')
end
