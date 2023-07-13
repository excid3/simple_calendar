require "test_helper"

class MonthCalendarTest < ActionView::TestCase
  test "date_range returns a full calendar month" do
    today = Date.today
    calendar = SimpleCalendar::MonthCalendar.new(view, start_date: today)
    assert calendar.date_range.min <= today.beginning_of_month
    assert calendar.date_range.max >= today.end_of_month
  end

  test "date_range returns the days of next and previous months on the edges of the calendar" do
    calendar = SimpleCalendar::MonthCalendar.new(view, start_date: Date.new(2018, 8, 1))
    assert_equal Date.new(2018, 7, 30), calendar.date_range.first
    assert_equal Date.new(2018, 9, 2), calendar.date_range.last
  end
end
