class BusinessWeekCalendar < SimpleCalendar::Calendar
  private

  def date_range
    beginning = start_date.monday
    ending = beginning + 5.days
    (beginning..ending).to_a
  end
end
