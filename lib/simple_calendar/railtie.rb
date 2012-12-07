module SimpleCalendar
  class Railtie < Rails::Railtie
    initializer "simple_calendar.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end
