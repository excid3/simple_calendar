require 'spec_helper'
require 'action_controller'
require 'simple_calendar/calendar'

describe '_calendar.html.erb', type: :view do
  let(:calendar) { SimpleCalendar::Calendar.new(ViewContext.new) }

  it 'should have the current week' do
    week = calendar.send(:date_range)
    expect(calendar.send(:tr_classes_for, week)).to include('current-week')
  end
end
