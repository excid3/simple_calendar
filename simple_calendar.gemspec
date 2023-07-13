$:.push File.expand_path("../lib", __FILE__)
require "simple_calendar/version"

Gem::Specification.new do |s|
  s.name = "simple_calendar"
  s.version = SimpleCalendar::VERSION
  s.authors = ["Chris Oliver"]
  s.email = ["excid3@gmail.com"]
  s.homepage = "https://github.com/excid3/simple_calendar"
  s.summary = "A simple Rails calendar"
  s.description = "A simple Rails calendar"
  s.license = "MIT"

  s.rubyforge_project = "simple_calendar"

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 6.1"
end
