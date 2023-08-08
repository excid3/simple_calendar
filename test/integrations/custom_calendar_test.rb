require "test_helper"

class CustomCalendarIntegrationTest < ActionDispatch::IntegrationTest
  test "renders a custom calendar" do
    get business_week_meetings_path
    assert_select "div.simple-calendar"
  end

  test "calendar renders events" do
    get business_week_meetings_path
    assert_select "div.simple-calendar" do
      assert_select "div", text: meetings(:one_day_event).name
    end
  end

  test "calendar render two day events" do
    event = meetings(:two_day_event)
    get business_week_meetings_path, params: {start_date: event.start_time.to_date}
    assert_select "div.simple-calendar" do
      assert_select "div", text: event.name, count: 2
    end
  end

  test "calendar render three day events" do
    event = meetings(:three_day_event)
    get business_week_meetings_path, params: {start_date: event.start_time.to_date}
    assert_select "div.simple-calendar" do
      assert_select "div", text: event.name, count: 3
    end
  end
end
