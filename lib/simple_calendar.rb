require "simple_calendar/calendar"
require "simple_calendar/month_calendar"
require "simple_calendar/week_calendar"
require "simple_calendar/model_additions"
require "simple_calendar/railtie"
require "simple_calendar/version"
require "simple_calendar/view_helpers"

module SimpleCalendar
  def self.extended(model_class)
    return if model_class.respond_to? :has_calendar

    model_class.class_eval do
      extend ModelAdditions
    end
  end
end
