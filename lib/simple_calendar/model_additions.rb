module SimpleCalendar
  module ModelAdditions
    def has_calendar(options={})
      config = { :attribute => [:starts_at, :ends_at] }
      # Override default config
      config.update(options) if options.is_a?(Hash)

      # let's do some sanitizing
      # is an array? 
      if config[:attribute].is_a?(Array)
        # unwanted nil removal
        config[:attribute].compact!
        # add default parameters if missing
        # first, fill empty array case
        config[:attribute] << :starts_at if config[:attribute].count < 1
        # next, fill second parameter if missing
        config[:attribute] << :ends_at if config[:attribute].count < 2
        # unneded extra parameter removal
        config[:attribute] = config[:attribute].take(2) if config[:attribute].count > 2
      else
        # supporting old option syntax
        config[:attribute] = [config[:attribute], :ends_at] 
      end
      class_eval <<-EOV
        def simple_calendar_start_time
          #{config[:attribute].first.to_s}
        end
        def simple_calendar_range_date
          (#{config[:attribute].first.to_s}.to_date..#{config[:attribute].last.to_s}.to_date)
        end
      EOV
    end
  end
end
