module SimpleCalendar
  class MonthCalendar < SimpleCalendar::Calendar
    def date_range
      (start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week).to_a
    end

    def url_for_previous_view
      url_for_date(date_range.first - 1.day)
    end
  end
end
