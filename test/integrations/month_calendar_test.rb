require "test_helper"

class MonthCalendarIntegrationTest < ActionDispatch::IntegrationTest
  test "renders a month calendar" do
    get meetings_path
    assert_select "div.simple-calendar"
  end

  test "renders the current month when the start_date param is not a date" do
    get meetings_path, params: {start_date: "garbage"}
    assert_response :success
    assert_select "time.calendar-title", text: "#{I18n.t("date.month_names")[Date.current.month]} #{Date.current.year}"
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

  test "navigation links ignore url_for options from request params" do
    get meetings_path, params: {
      original_script_name: "javascript:alert(1)//",
      host: "evil.example",
      protocol: "https",
      port: 1337,
      user: "a",
      password: "b",
      anchor: "x",
      only_path: false,
      use_route: "root"
    }

    assert_response :success
    hrefs = css_select(".calendar-heading a").map { |a| a["href"] }
    assert_equal 3, hrefs.size
    hrefs.each do |href|
      assert_match %r{\A/meetings\?[^#]*\z}, href, "unexpected href: #{href}"
    end
  end

  test "malicious url_for options do not raise" do
    get meetings_path, params: {protocol: "javascript:alert(1)//", host: "x"}
    assert_response :success

    get meetings_path, params: {use_route: "meeting"}
    assert_response :success
  end

  test "navigation links keep regular query params" do
    get meetings_path, params: {foo: "bar"}
    hrefs = css_select(".calendar-heading a").map { |a| a["href"] }
    assert_equal 3, hrefs.size
    hrefs.each { |href| assert_includes href, "foo=bar" }
  end
end
