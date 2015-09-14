require 'rails'

module SimpleCalendar
  class Calendar
    attr_accessor :view_context, :options

    def initialize(view_context, opts={})
      @view_context = view_context
      @options = opts
    end

    def render(&block)
      view_context.render(
        partial: partial_name,
        locals: {
          block: block,
          calendar: self,
          date_range: date_range,
          start_date: start_date,
          sorted_events: sorted_events
        }
      )
    end

    def td_classes_for(day)
      today = Time.zone.now.to_date

      td_class = ["day"]
      td_class << "wday-#{day.wday.to_s}"
      td_class << "today"         if today == day
      td_class << "past"          if today > day
      td_class << "future"        if today < day
      td_class << 'start-date'    if day.to_date == start_date.to_date
      td_class << "prev-month"    if start_date.month != day.month && day < start_date
      td_class << "next-month"    if start_date.month != day.month && day > start_date
      td_class << "current-month" if start_date.month == day.month
      td_class << "has-events"    if sorted_events.fetch(day, []).any?

      td_class
    end

    private

      def partial_name
        self.class.name.underscore
      end

      def attribute
        options.fetch(:attribute, :start_time).to_sym
      end

      def sorted_events
        events = options.fetch(:events, []).sort_by(&attribute)
        sorted = {}

        events.each do |event|
          start_time = event.send(attribute)
          if start_time.present?
            date = start_time.to_date
            sorted[date] ||= []
            sorted[date] << event
          end
        end

        sorted
      end

      def start_date
        view_context.params.fetch(:start_date, Date.today).to_date
      end

      def date_range
        (start_date..(start_date + additional_days.days)).to_a
      end

      def additional_days
        options.fetch(:number_of_days, 4) - 1
      end
  end
end
