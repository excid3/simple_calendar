require "spec_helper"
require "action_controller"
require "simple_calendar/calendar"
require "simple_calendar/month_calendar"
require "support/view_context"

describe SimpleCalendar::MonthCalendar do
  describe "#date_range" do
    it "renders a full calendar month" do
      today = Date.today
      calendar = SimpleCalendar::MonthCalendar.new(ViewContext.new, start_date: Date.today)

      expect(calendar.date_range.min).to be <= today.beginning_of_month
      expect(calendar.date_range.max).to be >= today.end_of_month
    end

    it "render the days of next and previous months on the edges of the calendar" do
      month = Date.new(2018, 8, 1)
      calendar = SimpleCalendar::MonthCalendar.new(ViewContext.new, start_date: month)

      expect(calendar.date_range.first).to eq Date.new(2018, 7, 30)
      expect(calendar.date_range.last).to eq Date.new(2018, 9, 2)
    end
  end
end
