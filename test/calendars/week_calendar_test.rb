require "test_helper"

class WeekCalendarTest < ActionView::TestCase
  test "defaults to one week" do
    calendar = SimpleCalendar::WeekCalendar.new(view)
    assert_equal 1, calendar.number_of_weeks
    assert_equal 7, calendar.date_range.count
    assert_equal calendar.week_number, calendar.end_week
  end

  test "date range covers the requested number of whole weeks" do
    calendar = SimpleCalendar::WeekCalendar.new(view, start_date: Date.new(2025, 12, 24), number_of_weeks: 3)
    assert_equal Date.new(2025, 12, 22), calendar.date_range.first
    assert_equal Date.new(2026, 1, 11), calendar.date_range.last
  end

  test "week number and end week within the same year" do
    calendar = SimpleCalendar::WeekCalendar.new(view, start_date: Date.new(2025, 6, 2), number_of_weeks: 3)
    assert_equal 23, calendar.week_number
    assert_equal 25, calendar.end_week
  end

  test "end week wraps across the year end with a monday week start" do
    with_beginning_of_week(:monday) do
      calendar = SimpleCalendar::WeekCalendar.new(view, start_date: Date.new(2025, 12, 22), number_of_weeks: 3)
      assert_equal 52, calendar.week_number
      assert_equal 2, calendar.end_week
    end
  end

  test "end week wraps across the year end with a sunday week start" do
    with_beginning_of_week(:sunday) do
      calendar = SimpleCalendar::WeekCalendar.new(view, start_date: Date.new(2025, 12, 21), number_of_weeks: 3)
      assert_equal 51, calendar.week_number
      assert_equal 1, calendar.end_week
    end
  end

  private

  def with_beginning_of_week(day)
    original = Date.beginning_of_week
    Date.beginning_of_week = day
    yield
  ensure
    Date.beginning_of_week = original
  end
end
