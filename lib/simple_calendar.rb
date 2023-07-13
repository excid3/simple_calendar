require "simple_calendar/engine"
require "simple_calendar/calendar"
require "simple_calendar/month_calendar"
require "simple_calendar/week_calendar"
require "simple_calendar/version"
require "simple_calendar/view_helpers"

module SimpleCalendar
  autoload :Calendar, "simple_calendar/calendar"
  autoload :MonthCalendar, "simple_calendar/month_calendar"
  autoload :WeekCalendar, "simple_calendar/week_calendar"
  autoload :ViewHelpers, "simple_calendar/view_helpers"
end
