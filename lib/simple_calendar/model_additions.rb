module SimpleCalendar
  module ModelAdditions
    def has_calendar(options={})
      config = { :start_time => "start_time"}
      config.update(options) if options.is_a?(Hash)

      class_eval <<-EOV
        def start_time_column
          #{config[:start_time]}
        end
      EOV
    end
  end
end

