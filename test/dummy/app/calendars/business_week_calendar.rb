class BusinessWeekCalendar < SimpleCalendar::Calendar
  # The pattern older custom calendars copied from MonthCalendar
  def url_for_previous_view
    view_context.url_for(@params.merge(start_date_param => (date_range.first - 1.day).iso8601))
  end

  private

  def date_range
    beginning = start_date.monday
    ending = beginning + 5.days
    (beginning..ending).to_a
  end
end
