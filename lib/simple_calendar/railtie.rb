module SimpleCalendar
  class Railtie < Rails::Railtie
    initializer "simple_calendar.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
    initializer "simple_calendar.model_additions" do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
      end
    end
  end
end
