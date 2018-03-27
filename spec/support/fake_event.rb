class FakeEvent
  attr_accessor :name, :start_time, :end_time

  def initialize(name='event', start_time=nil, end_time=nil)
    @name       = name
    @start_time = start_time
    @end_time   = end_time
  end
end
