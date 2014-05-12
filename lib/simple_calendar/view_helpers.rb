module SimpleCalendar
  module ViewHelpers
    def month_calendar(start_date=nil, options={}, &block)
      start_date ||= Time.zone.now
      start_date = start_date.to_date

      render_calendar month_range(start_date), options, &block
    end

    def month_range(start_date)
      starting_day  = start_date.beginning_of_month.beginning_of_week.to_date
      ending_day    = start_date.end_of_month.end_of_week.to_date
      starting_day..ending_day
    end

    def week_calendar(start_date=nil, options={}, &block)
      start_date ||= Time.zone.now
      start_date = start_date.to_date
      number_of_weeks = options.fetch(:number_of_weeks, 1)

      render_calendar week_range(start_date, number_of_weeks), options, &block
    end

    def week_range(start_date, number_of_weeks)
      number_of_days_to_advance = (number_of_weeks * 7) - 1
      starting_day = start_date.beginning_of_week.to_date
      ending_day   = starting_day + number_of_days_to_advance.days
      starting_day..ending_day
    end

    def calendar(start_date=nil, options={}, &block)
      start_date ||= Time.zone.now
      start_date = start_date.to_date
      number_of_days_to_advance = options.fetch(:number_of_days, 4) - 1

      render_calendar calendar_range(start_date, number_of_days_to_advance), options, &block
    end

    def calendar_range(start_date, number_of_days_to_advance)
      starting_day  = start_date.to_date
      ending_day    = starting_day + number_of_days_to_advance.days
      starting_day..ending_day
    end

    def render_calendar(range, options, &block)
      raise 'SimpleCalendar requires a block' unless block_given?

      @block   = block
      @options = options.reverse_merge default_options

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
