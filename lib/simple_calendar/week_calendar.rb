module SimpleCalendar
  class WeekCalendar < SimpleCalendar::Calendar
    def week_number
      format = (Date.beginning_of_week == :sunday) ? "%U" : "%V"
      start_date.beginning_of_week.strftime(format).to_i
    end

    def number_of_weeks
      options.fetch(:number_of_weeks, 1)
    end

    def end_week
      week_number + number_of_weeks - 1
    end

    def date_range
      starting = start_date.beginning_of_week
      ending = (starting + (number_of_weeks - 1).weeks).end_of_week

      (starting..ending).to_a
    end
  end
end
