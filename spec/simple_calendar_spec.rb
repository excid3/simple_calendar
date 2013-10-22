require 'helper'

class View
  include SimpleCalendar::ViewHelpers
  include ActionView::Helpers
  include ActionView::Context

  def raw(argument)
    argument
  end

end

describe "SimpleCalendar" do
  subject { View.new }

  before do
    subject.stub(:params => {:year => 2013, :month => 5})
  end

  describe "#calendar" do
    context "with invalid arguments" do
      it "should raise an error" do
        expect { subject.calendar("foo") }.to raise_error(StandardError, /block/)
      end
    end

    context "with valid arguments" do
      it "should draw a calendar" do
        subject.should_receive(:draw_calendar)
        subject.calendar("foo") { "test" }
      end

      it "should not overwrite passed in arguments" do
        subject.should_receive(:build_range).and_return([2,2,3])
        subject.should_receive(:draw_calendar)
        subject.calendar("foo") { "test" }
      end
    end
  end

  describe "#build_range" do
    it "should return an array representing the days of the month" do
      selected_month = Date.new(2013, 1)
      options        = {:start_day => :tuesday}
      result         = subject.send(:build_range, selected_month, options)
      result.class.should == Array
      result.first.class.should == Date
      result.last.class.should == Date
    end
  end

  describe "#draw_calendar" do
    it "should render a calendar table" do
      #TODO: refactor draw_calendar to not require so much build up
      subject.should_receive(:month_header)
      selected_month = Date.new(2013, 1)
      month          = []
      current_date   = Date.new(2013, 1, 14)
      events         = {}
      options        = {:start_day => :monday}
      block          = Proc.new {}
      subject.send(:draw_calendar, selected_month, month, current_date, events, options, block).should match(/^<table/)
    end
  end

  describe "#day_events" do
    it "should return an array of events for a given day" do
      date           = Date.new(2013, 1, 14)
      matching_event = stub(:start_time => Date.new(2013, 1, 14))
      other_event    = stub(:start_time => Date.new(2013,1,15))
      events = [matching_event, other_event]
      subject.send(:day_events, date, events, "start_time").should == [matching_event]
    end
  end

  describe "#month_header" do
    it "should generate html including the month, next and previous month" do
      subject.should_receive(:month_link).exactly(2)
      selected_month = Date.new(2013, 1)
      options = {}
      #TODO: add coverage for actual output other than just the starting tag
      subject.send(:month_header, selected_month, options).should match(/^<h2/)
    end
  end

  describe "#month_link" do
    it "should return a link" do
      #TODO: test even needed?
      subject.should_receive(:link_to)
      subject.send(:month_link, "previous", Date.new(2013, 1), {})
    end
  end
end
