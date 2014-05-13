module SimpleCalendar
  module ModelAdditions
    def has_calendar(options={})
      config = { :attribute => :starts_at }

      # Override default config
      config.update(options) if options.is_a?(Hash)

      class_eval <<-EOV
        def simple_calendar_start_time
          #{config[:attribute]}
        end
      EOV
    end
  end
end
