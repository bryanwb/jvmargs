# nothing here yet!
require 'rspec'
require 'rspec/mocks'
require 'ohai'

RSpec.configure do |config|
  config.before(:each) { allow_any_instance_of(Ohai::System).to receive(:[]).with('memory').and_return({'total' => '24G'}) }
end
