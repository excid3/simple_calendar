require "test_helper"

class MonthCalendarIntegrationTest < ActionDispatch::IntegrationTest
  test "renders a month calendar" do
    get meetings_path
    assert_select "div.simple-calendar"
  end

  test "month calendar renders events" do
    get meetings_path
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:one_day_event).name
    end
  end

  test "month calendar render two day events" do
    get meetings_path
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:two_day_event).name, count: 2
    end
  end

  test "month calendar render three day events" do
    get meetings_path
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:three_day_event).name, count: 3
    end
  end

  test "Month calendar can navigate to the past" do
    get meetings_path, params: {start_date: Time.current - 5.years}
    # meetings?start_date=2022-09-25
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:event_in_the_past).name
    end
  end

  test "Month calendar can navigate to the past and render two day events" do
    get meetings_path, params: {start_date: Time.current - 4.years}
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:events_in_the_past).name, count: 2
    end
  end

  test "Month calendar can navigate to the future and render one day events" do
    get meetings_path, params: {start_date: Time.current + 4.years}
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:one_day_event_in_the_future).name
    end
  end

  test "Month calendar can navigate to the future and render two day events" do
    get meetings_path, params: {start_date: Time.current + 5.years}
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:two_day_events_in_the_future).name
    end
  end
end
