module SimpleCalendar
  class MonthCalendar < SimpleCalendar::Calendar
    def url_for_previous_view
      view_context.url_for(@params.merge(start_date_param => (date_range.first - 1.day).iso8601))
    end

    def date_range
      (start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week).to_a
    end
  end
end
