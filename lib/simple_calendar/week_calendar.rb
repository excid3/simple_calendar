module SimpleCalendar
  class WeekCalendar < SimpleCalendar::Calendar
    private

      def date_range
        starting = start_date.beginning_of_week
        ending = (starting + (number_of_weeks - 1).weeks).end_of_week

        (starting..ending).to_a
      end

      def number_of_weeks
        options.fetch(:number_of_weeks, 1)
      end
  end
end
