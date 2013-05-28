$:.unshift(File.expand_path('../../lib', __FILE__))

require 'pathname'
require 'rubygems'
require 'bundler'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')

Bundler.setup(:default)

Dir[root_path.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.fail_fast = true

  config.filter_run :focused => true
  config.alias_example_to :fit, :focused => true
  config.alias_example_to :xit, :pending => true
  config.run_all_when_everything_filtered = true
end
