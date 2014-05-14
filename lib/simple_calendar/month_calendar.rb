module SimpleCalendar
  class MonthCalendar < Calendar
    def date_range
      @date_range ||= start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week
    end

    def default_title
      ->(start_date) { content_tag :span, month_name(start_date) }
    end

    def month_name(start_date)
      "#{I18n.t("date.month_names")[start_date.month]} #{start_date.year}"
    end
  end
end

