require 'spec_helper'
require 'simple_calendar/calendar'

class ViewContext
  attr_accessor :start_date

  def initialize(start_date=nil)
    @start_date = start_date
  end

  def params
    if @start_date.present?
      {start_date: @start_date}
    else
      {}
    end
  end
end

describe SimpleCalendar::Calendar do
  let(:calendar) { SimpleCalendar::Calendar.new(nil) }

  it 'renders a partial with the same name as the class' do
    expect(calendar.send(:partial_name)).to eq("simple_calendar/calendar")
  end

  context 'event sorting attribute' do
    it 'has start_time as the default attribute' do
      expect(calendar.send(:attribute)).to eq(:start_time)
    end

    it 'allows you to override the default attribute' do
      expect(SimpleCalendar::Calendar.new(nil, attribute: :starts_at).send(:attribute)).to eq(:starts_at)
    end
  end

  describe "#sorted_events" do
    it 'converts an array of events to a hash sorted by days'
  end

  describe "#start_date" do
    it "defaults to today's date" do
      view_context = ViewContext.new()
      calendar = SimpleCalendar::Calendar.new(view_context)
      expect(calendar.send(:start_date)).to eq(Date.today)
    end

    it "uses the params start_date to override" do
      view_context = ViewContext.new(Date.yesterday)
      calendar = SimpleCalendar::Calendar.new(view_context)
      expect(calendar.send(:start_date)).to eq(Date.yesterday)
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
