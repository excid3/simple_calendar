require "simple_calendar/engine"
require "simple_calendar/version"

module SimpleCalendar
  autoload :Calendar, "simple_calendar/calendar"
  autoload :MonthCalendar, "simple_calendar/month_calendar"
  autoload :WeekCalendar, "simple_calendar/week_calendar"
end
