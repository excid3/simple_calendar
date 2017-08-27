require 'spec_helper'
require 'action_controller'
require 'simple_calendar/calendar'

describe 'simple_calendar/_calendar.html.erb', type: :view do
  it 'should have the current week' do
    # assign(:calendar, SimpleCalendar::Calendar.new(ViewContext.new))

    # render template: 'simple_calendar/_calendar.html.erb'
    render
    expect(rendered).to have_css 'tr.current-week'
  end

  # it {
  #   should have_css('div.simple-calendar')
  # }
end
