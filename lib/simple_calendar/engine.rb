module SimpleCalendar
  class Engine < Rails::Engine
    initializer "simple_calendar.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include ViewHelpers
      end
    end
  end
end
