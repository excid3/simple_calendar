require "spec_helper"
require "action_controller"
require "simple_calendar/calendar"
require "simple_calendar/week_calendar"
require "support/view_context"

describe SimpleCalendar::WeekCalendar do
  let(:today) { Date.today }
  let(:view_context) { ViewContext.new }
  let(:calendar) { described_class.new(view_context, start_date: today) }

  describe 'navigation links' do
    let(:start_date_param) { calendar.send(:start_date_param) }
    let(:date_range) { calendar.send(:date_range) }

    it "has a previous view link" do
      query_params = { start_date_param => (date_range.first - 1.day).iso8601 }
      expect(calendar.url_for_previous_view).to eq "/my-calendar?#{query_params.to_query}"
    end
  end

  describe '#week_number' do
    subject { calendar.week_number }

    it { is_expected.to eq today.beginning_of_week.strftime("%V").to_i }

    context "when the beginning of the week is set to be Sunday" do
      before { Date.beginning_of_week = :sunday }

      it { is_expected.to eq today.beginning_of_week.strftime("%U").to_i }

      after { Date.beginning_of_week = :monday }
    end
  end

  describe "#number_of_weeks" do
    subject { calendar.number_of_weeks }

    it { is_expected.to eq 1 }

    context 'when a number of weeks is passed to the calendar' do
      let(:calendar) { described_class.new(view_context, start_date: today, number_of_weeks: 3) }

      it { is_expected.to eq 3 }
    end
  end

  describe '#end_week' do
    subject { calendar.end_week }

    it { is_expected.to eq calendar.week_number }

    context 'when a number of weeks is passed to the calendar' do
      let(:calendar) { described_class.new(view_context, start_date: today, number_of_weeks: 3) }

      it { is_expected.to eq calendar.week_number + 2 }
    end
  end

  describe "#date_range" do
    it "renders a full calendar week" do
      expect(calendar.date_range.min).to eq today.beginning_of_week
      expect(calendar.date_range.max).to eq today.end_of_week
    end

    context 'when a number of weeks is passed to the calendar' do
      let(:calendar) { described_class.new(view_context, start_date: today, number_of_weeks: 3) }

      it "renders a calendar with the corresponding number weeks" do
        expect(calendar.date_range.min).to eq today.beginning_of_week
        expect(calendar.date_range.max).to eq (today + 2.weeks).end_of_week
      end
    end
  end
end
