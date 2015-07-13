module SimpleCalendar
  class WeekCalendar < SimpleCalendar::Calendar
    private

      def date_range
        (start_date.beginning_of_week..start_date.end_of_week).to_a
      end
  end
end
