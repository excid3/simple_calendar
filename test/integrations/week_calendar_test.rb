require "test_helper"

class WeekCalendarTest < ActionDispatch::IntegrationTest
  test "renders a week calendar" do
    get meetings_path
    assert_select "div.week-calendar"
  end

  test "week calendar renders a one day event" do
    get meetings_path
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:one_day_event).name
    end
  end

  test "weekly calendar render two day events" do
    get meetings_path
    assert_select "div.week-calendar" do
      assert_select "div", text: meetings(:week_two_day_event).name, count: 2
    end
  end

  test "month calendar render two day events" do
    get meetings_path
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:two_day_event).name, count: 2
    end
  end

  test "week calendar render three day events" do
    get meetings_path
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:three_day_event).name, count: 3
    end
  end

  test "Week calendar can navigate to the past" do
    get meetings_path, params: {start_date: Time.current - 5.years}
    assert_select "div.week-calendar" do
      assert_select "div", text: meetings(:event_in_the_past).name
    end
  end

  test "Week calendar can navigate to the past and render two day events" do
    get meetings_path, params: {start_date: Time.current.beginning_of_week - 2.years} 
    assert_select "div.week-calendar" do
      assert_select "div", text: meetings(:week_two_day_event_in_the_past).name, count: 2
    end
  end

  test "Week calendar can navigate to the future and render one day events" do
    get meetings_path, params: {start_date: Time.current.beginning_of_week + 6.years}
    assert_select "div.week-calendar" do
      assert_select "div", text: meetings(:week_one_day_event_in_the_future).name
    end
  end

  test "Week calendar can navigate to the future and render two day events" do
    get meetings_path, params: {start_date: Time.current + 5.years}
    assert_select "div.week-calendar" do
      assert_select "div", text: meetings(:two_day_events_in_the_future).name
    end
  end
end
