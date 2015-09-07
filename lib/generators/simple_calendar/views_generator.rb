require 'rails/generators'

module SimpleCalendar
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../..", __FILE__)

      def copy_views
        directory 'app/views/simple_calendar', 'app/views/simple_calendar'
      end
    end
  end
end
