class ApplicationRecord < ActiveRecord::Base
  if Rails.gem_version >= Gem::Version.new("7.0")
    primary_abstract_class
  else
    self.abstract_class = true
  end
end
