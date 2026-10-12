require "test_helper"

class WeekCalendarTest < ActionView::TestCase
  test "end_week is the week number of the last visible week" do
    calendar = SimpleCalendar::WeekCalendar.new(view, start_date: Date.new(2025, 3, 3), number_of_weeks: 3)
    assert_equal [10, 12], [calendar.week_number, calendar.end_week]
  end

  test "end_week wraps to the next year" do
    calendar = SimpleCalendar::WeekCalendar.new(view, start_date: Date.new(2025, 12, 22), number_of_weeks: 3)
    assert_equal [52, 2], [calendar.week_number, calendar.end_week]
  end

  test "end_week wraps to the next year when weeks start on sunday" do
    Date.beginning_of_week = :sunday
    calendar = SimpleCalendar::WeekCalendar.new(view, start_date: Date.new(2025, 12, 21), number_of_weeks: 3)
    assert_equal [51, 1], [calendar.week_number, calendar.end_week]
  ensure
    Date.beginning_of_week = :monday
  end
end
