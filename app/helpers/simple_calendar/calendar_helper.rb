module SimpleCalendar
  module CalendarHelper
    def calendar(options = {}, &block)
      raise "calendar requires a block" unless block
      render SimpleCalendar::Calendar.new(self, options), &block
    end

    def month_calendar(options = {}, &block)
      raise "month_calendar requires a block" unless block
      render SimpleCalendar::MonthCalendar.new(self, options), &block
    end

    def week_calendar(options = {}, &block)
      raise "week_calendar requires a block" unless block
      render SimpleCalendar::WeekCalendar.new(self, options), &block
    end
  end
end
