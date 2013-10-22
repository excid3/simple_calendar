require 'pathname'
require 'rubygems'
require 'bundler'
require 'pry'
require 'active_support/all'
require 'action_view'

root_path = Pathname(__FILE__).dirname.join('..').expand_path
lib_path  = root_path.join('lib')

Dir[root_path.join("spec/support/*.rb")].each { |f| require f }
Dir[lib_path.join("simple_calendar/*.rb")].each { |f| require f }

Bundler.setup(:default)

RSpec.configure do |config|
  config.fail_fast = true

  config.filter_run :focused => true
  config.alias_example_to :fit, :focused => true
  config.alias_example_to :xit, :pending => true
  config.run_all_when_everything_filtered = true
end
Time.zone = "UTC"