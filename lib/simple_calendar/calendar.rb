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
        partial: self.class.name.underscore,
        locals: {
          date_range: date_range,
          start_date: start_date,
          sorted_events: sorted_events
        }
      )
    end

    private

      def sorted_events
        events = options.fetch(:events, [])
        sorted = {}

        events.each do |event|
          date = event.start_time.to_date
          sorted[date] ||= []
          sorted[date] << event
          sorted[date] = sorted[date].sort_by(&:start_time)
        end

        # TODO: move sorting by start_time to after the event loop

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
