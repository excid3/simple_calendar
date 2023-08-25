require "test_helper"

class CalendarTest < ActionView::TestCase
  attr_reader :calendar

  setup do
    @calendar = SimpleCalendar::Calendar.new(view)
  end

  test "renders a partial with the same name as the class" do
    assert_equal "simple_calendar/calendar", calendar.partial_name
  end

  test "has start_time as the default attribute" do
    assert_equal :start_time, calendar.attribute
  end

  test "allows you to override the default attribute" do
    assert_equal :starts_at, SimpleCalendar::Calendar.new(view, attribute: :starts_at).attribute
  end

  test "set a default when `partial` option isn't present" do
    assert_equal "simple_calendar/calendar", SimpleCalendar::Calendar.new(view).partial_name
    assert_equal "simple_calendar/month_calendar", SimpleCalendar::MonthCalendar.new(view).partial_name
    assert_equal "simple_calendar/week_calendar", SimpleCalendar::WeekCalendar.new(view).partial_name
  end

  test "allows to override the default partial" do
    assert_equal "simple_calendar/custom_calendar", SimpleCalendar::Calendar.new(view, partial: "simple_calendar/custom_calendar").partial_name
  end

  test "converts an array of events to a hash sorted by days" do
    today, tomorrow = Date.today, Date.tomorrow

    event1 = Meeting.new(start_time: today.at_midnight)
    event2 = Meeting.new(start_time: today.at_noon)
    event3 = Meeting.new(start_time: tomorrow.at_noon)

    events = [event1, event2, event3].shuffle
    calendar = SimpleCalendar::Calendar.new(view, events: events)

    sorted_events = calendar.sorted_events

    assert_equal [event1, event2], sorted_events[today]
    assert_equal [event3], sorted_events[tomorrow]
  end

  test "converts an array of multi-day events to a hash sorted by days" do
    today, tomorrow = Date.today, Date.tomorrow

    event1 = Meeting.new(start_time: today.at_midnight, end_time: tomorrow.at_midnight)
    event2 = Meeting.new(start_time: today.at_noon)
    event3 = Meeting.new(start_time: tomorrow.at_noon)

    events = [event1, event2, event3].shuffle
    calendar = SimpleCalendar::Calendar.new(view, events: events)

    assert_equal [event1, event2], calendar.sorted_events[today]
    assert_equal [event1, event3], calendar.sorted_events[tomorrow]
  end

  test "handles events without a start time" do
    event = Meeting.new(start_time: nil)
    calendar = SimpleCalendar::Calendar.new(view, events: [event])

    assert_nothing_raised do
      calendar.sorted_events
    end
  end

  test "defaults to today's date" do
    calendar = SimpleCalendar::Calendar.new(view)
    assert_equal Date.today, calendar.start_date
  end

  test "uses the view context's params start_date to override" do
    params[:start_date] = Date.yesterday
    calendar = SimpleCalendar::Calendar.new(view)
    assert_equal Date.yesterday, calendar.start_date
  end

  test "uses the optional argument's start_date to override view_context's start_date" do
    params[:start_date] = Date.yesterday
    calendar = SimpleCalendar::Calendar.new(view, start_date: Date.tomorrow)
    assert_equal Date.tomorrow, calendar.start_date
  end

  test "takes an option to override the start_date parameter" do
    params[:date] = Date.yesterday
    calendar = SimpleCalendar::Calendar.new(view, start_date_param: :date)
    assert_equal Date.yesterday, calendar.start_date
  end

  test "should have the current week" do
    calendar = SimpleCalendar::Calendar.new(view)
    week = calendar.date_range.each_slice(7).to_a[0]
    assert_includes calendar.tr_classes_for(week), "current-week"
  end

  test "should not have the current week if it does not contain today" do
    params[:start_date] = 6.months.ago
    calendar = SimpleCalendar::MonthCalendar.new(view)
    week = calendar.date_range.each_slice(7).to_a[0]
    assert_not_includes calendar.tr_classes_for(week), "current-week"
  end

  test "has a param that determines the start date of the calendar" do
    calendar = SimpleCalendar::Calendar.new(view)
    rendering_variables = calendar.locals
    assert_not_nil rendering_variables[:start_date]
  end

  test "generates a default date if no start date is present" do
    calendar = SimpleCalendar::Calendar.new(view)
    calendar_start_date = calendar.locals[:start_date]
    assert_not_nil calendar_start_date
    assert_kind_of Date, calendar_start_date
  end

  test "has a range of dates" do
    calendar = SimpleCalendar::Calendar.new(view)
    calendar_date_range = calendar.date_range
    assert_kind_of Array, calendar_date_range
    calendar_date_range.each do |date|
      assert_kind_of Date, date
    end
  end

  test "handles nil events" do
    assert_nothing_raised do
      calendar = SimpleCalendar::Calendar.new(view, events: nil)
      calendar.sorted_events.first
    end
  end

  test "accepts an array of events" do
    first_event = Meeting.new(name: "event1", start_time: Date.today)
    second_event = Meeting.new(name: "event2", start_time: Date.today + 1.day)
    events = [first_event, second_event]
    calendar = SimpleCalendar::Calendar.new(view, events: events)
    calendar_sorted_events = calendar.locals[:sorted_events]

    assert_equal 2, calendar_sorted_events.length
  end

  test "sorts the events" do
    first_event = Meeting.new(name: "event1", start_time: Date.today + 2.days)
    second_event = Meeting.new(name: "event2", start_time: Date.today + 1.day)
    third_event = Meeting.new(name: "event3", start_time: Date.today)
    events = [first_event, third_event, second_event]
    calendar = SimpleCalendar::Calendar.new(view, events: events)
    calendar_sorted_events = calendar.locals[:sorted_events]
    first_key = calendar_sorted_events.keys[0]
    second_key = calendar_sorted_events.keys[1]
    third_key = calendar_sorted_events.keys[2]

    assert_equal third_event, calendar_sorted_events[first_key][0]
    assert_equal second_event, calendar_sorted_events[second_key][0]
    assert_equal first_event, calendar_sorted_events[third_key][0]
  end
end
