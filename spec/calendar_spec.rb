require 'spec_helper'
require 'action_controller'
require 'simple_calendar/calendar'

class ViewContext
  attr_accessor :start_date

  def initialize(start_date=nil)
    @start_date = start_date
  end

  def params
    if @start_date.present?
      ActionController::Parameters.new({start_date: @start_date})
    else
      ActionController::Parameters.new
    end
  end
end

describe SimpleCalendar::Calendar do
  let(:calendar) { SimpleCalendar::Calendar.new(ViewContext.new) }

  it 'renders a partial with the same name as the class' do
    expect(calendar.send(:partial_name)).to eq("simple_calendar/calendar")
  end

  context 'event sorting attribute' do
    it 'has start_time as the default attribute' do
      expect(calendar.send(:attribute)).to eq(:start_time)
    end

    it 'allows you to override the default attribute' do
      expect(SimpleCalendar::Calendar.new(ViewContext.new, attribute: :starts_at).send(:attribute)).to eq(:starts_at)
    end

    it "set a default when `partial` option isn't present" do
      expect(SimpleCalendar::Calendar.new(ViewContext.new).send(:partial_name)).to eq('simple_calendar/calendar')
      expect(SimpleCalendar::MonthCalendar.new(ViewContext.new).send(:partial_name)).to eq('simple_calendar/month_calendar')
      expect(SimpleCalendar::WeekCalendar.new(ViewContext.new).send(:partial_name)).to eq('simple_calendar/week_calendar')
    end

    it 'allows to override the default partial' do
      expect(SimpleCalendar::Calendar.new(ViewContext.new, partial: 'simple_calendar/custom_calendar').send(:partial_name)).to eq('simple_calendar/custom_calendar')
    end
  end

  describe "#sorted_events" do
    it 'converts an array of events to a hash sorted by days' do
      today, tomorrow = Date.today, Date.tomorrow

      event1 = double(start_time: today.at_midnight)
      event2 = double(start_time: today.at_noon)
      event3 = double(start_time: tomorrow.at_noon)

      events = [event1, event2, event3].shuffle
      calendar = SimpleCalendar::Calendar.new(ViewContext.new, events: events)

      sorted_events = calendar.send(:sorted_events)

      expect(sorted_events[today]).to eq([event1, event2])
      expect(sorted_events[tomorrow]).to eq([event3])
    end

    it 'converts an array of multi-day events to a hash sorted by days' do
      today, tomorrow = Date.today, Date.tomorrow

      event1 = double(start_time: today.at_midnight, end_time: tomorrow.at_midnight)
      event2 = double(start_time: today.at_noon)
      event3 = double(start_time: tomorrow.at_noon)

      events = [event1, event2, event3].shuffle
      calendar = SimpleCalendar::Calendar.new(ViewContext.new, events: events)

      sorted_events = calendar.send(:sorted_events)

      expect(sorted_events[today]).to eq([event1, event2])
      expect(sorted_events[tomorrow]).to eq([event1, event3])
    end

    it 'handles events without a start time' do
      event = double(start_time: nil)
      calendar = SimpleCalendar::Calendar.new(ViewContext.new, events: [event])

      expect{calendar.send(:sorted_events)}.not_to raise_error
    end
  end

  describe "#start_date" do
    it "defaults to today's date" do
      view_context = ViewContext.new()
      calendar = SimpleCalendar::Calendar.new(view_context)
      expect(calendar.send(:start_date)).to eq(Date.today)
    end

    it "uses the view context's params start_date to override" do
      view_context = ViewContext.new(Date.yesterday)
      calendar = SimpleCalendar::Calendar.new(view_context)
      expect(calendar.send(:start_date)).to eq(Date.yesterday)
    end

    it "uses the optional argument's start_date to override view_context's start_date" do
      view_context = ViewContext.new(Date.yesterday)
      calendar = SimpleCalendar::Calendar.new(view_context, start_date: Date.tomorrow)
      expect(calendar.send(:start_date)).to eq(Date.tomorrow)
    end
  end

  it 'has a param that determines the start date of the calendar'
  it 'generates a default date if no start date is present'
  it 'has a range of dates'

  it 'can split the range of dates into weeks'
  it 'has a title'
  it 'has a next view link'
  it 'has a previous view link'

  it 'accepts an array of events'
  it 'sorts the events'
  it 'yields the events for each day'

  it "doesn't crash when an event has a nil start_time"
end
