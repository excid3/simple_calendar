module SimpleCalendar
  class Engine < Rails::Engine
    initializer "simple_calendar.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end
