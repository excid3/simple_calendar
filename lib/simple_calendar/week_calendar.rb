module SimpleCalendar
  class WeekCalendar < Calendar
    def date_range
      @date_range ||= begin
                        number_of_weeks = options.fetch(:number_of_weeks, 1)
                        number_of_days  = (number_of_weeks * 7) - 1
                        starting_day              = start_date.beginning_of_week.to_date
                        ending_day                = starting_day + number_of_days.days
                        starting_day..ending_day
                      end
    end

    def default_previous_link
      ->(param, date_range) { link_to raw("&laquo;"), param => date_range.first - (((options.fetch(:number_of_weeks, 1) - 1) * 7) + 1).days }
    end

    def default_next_link
      ->(param, date_range) { link_to raw("&raquo;"), param => date_range.last + 1.day }
    end
  end
end

