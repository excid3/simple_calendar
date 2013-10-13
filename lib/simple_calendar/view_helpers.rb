module SimpleCalendar
  module ViewHelpers

    def calendar(range, options={}, &block)
      raise 'SimpleCalendar requires a block to be passed in' unless block_given?

      @block   = block
      @options = options.reverse_merge default_options

      render_calendar(range)
    end

    def render_calendar(range)
      content_tag :table, get_options(@options[:table]) do
        content_tag :tbody do
          render_weeks(range)
        end
      end
    end

    def render_weeks(range)
      weeks = []
      range.each_slice(7) do |week|
        weeks << content_tag(:tr, get_options(@options[:tr], week)) do
          render_week(week)
        end
      end
      safe_join weeks
    end

    def render_week(week)
      results = week.map do |day|
        content_tag :td, get_options(@options[:td], day) do
          @block.call(day)
        end
      end
      safe_join results
    end

    def get_options(options, *params)
      case options
      when Hash
        options
      when String
        send(options, *params)
      when Symbol
        send(options, *params)
      else
        options.call(*params) if options.respond_to? :call
      end
    end

    def default_options
      { table: {}, tr: {}, td: {}, }
    end

  end
end
