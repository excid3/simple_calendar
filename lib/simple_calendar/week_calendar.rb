module SimpleCalendar
  class WeekCalendar < SimpleCalendar::Calendar
    def week_number
      week_number_for(start_date)
    end

    def number_of_weeks
      options.fetch(:number_of_weeks, 1)
    end

    # Computed from the date, not week_number + n, so it wraps across a year boundary.
    def end_week
      week_number_for(date_range.last)
    end

    def date_range
      starting = start_date.beginning_of_week
      ending = (starting + (number_of_weeks - 1).weeks).end_of_week

      (starting..ending).to_a
    end

    def url_for_previous_view
      url_for_date(date_range.first - 1.day)
    end

    private

    def week_number_for(date)
      format = (Date.beginning_of_week == :sunday) ? "%U" : "%V"
      date.beginning_of_week.strftime(format).to_i
    end
  end
end
