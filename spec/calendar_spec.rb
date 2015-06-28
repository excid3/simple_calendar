require 'spec_helper'
require 'simple_calendar/calendar'

describe SimpleCalendar::Calendar do
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
end
