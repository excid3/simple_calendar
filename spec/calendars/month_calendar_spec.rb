require "spec_helper"
require "action_controller"
require "simple_calendar/calendar"
require "simple_calendar/month_calendar"
require "support/view_context"

describe SimpleCalendar::MonthCalendar do
  let(:today) { Date.today }
  let(:view_context) { ViewContext.new }
  let(:calendar) { described_class.new(view_context, start_date: today) }

  describe "navigation links" do
    let(:start_date_param) { calendar.send(:start_date_param) }
    let(:date_range) { calendar.send(:date_range) }

    it "has a previous view link" do
      query_params = {start_date_param => (date_range.first - 1.day).iso8601}
      expect(calendar.url_for_previous_view).to eq "/my-calendar?#{query_params.to_query}"
    end
  end

  describe "#date_range" do
    it "renders a full calendar month" do
      expect(calendar.date_range.min).to be <= today.beginning_of_month
      expect(calendar.date_range.max).to be >= today.end_of_month
    end

    context "when rendering a full calendar month" do
      let(:month) { Date.new(2018, 8, 1) }
      let(:calendar) { described_class.new(view_context, start_date: month) }

      it "renders the days of next and previous months on the edges of the calendar" do
        expect(calendar.date_range.first).to eq Date.new(2018, 7, 30)
        expect(calendar.date_range.last).to eq Date.new(2018, 9, 2)
      end
    end
  end
end
