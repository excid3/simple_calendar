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
          events: options.fetch(:events, [])
        }
      )
    end

    private

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
