require 'spec_helper'
require 'action_controller'
require 'simple_calendar/calendar'

describe '_calendar.html.erb', type: :view do
  let(:calendar) { SimpleCalendar::Calendar.new(ViewContext.new) }

  it 'should have the current week' do
    week = calendar.send(:date_range).each_slice(7).to_a[0]
    expect(calendar.send(:tr_classes_for, week)).to include('current-week')
  end

  it 'should not have the current week if it does not contain today' do
    view_context = ViewContext.new(Date.new(2017, 8, 1), start_date_param: :date)
    calendar = SimpleCalendar::Calendar.new(view_context, start_date_param: :date)
    week = calendar.send(:date_range).each_slice(7).to_a[0]
    expect(calendar.send(:tr_classes_for, week)).to_not include('current-week')
  end
end
