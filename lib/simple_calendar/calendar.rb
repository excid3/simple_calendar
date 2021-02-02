require "rails"

module SimpleCalendar
  class Calendar
    PARAM_KEY_BLACKLIST = :authenticity_token, :commit, :utf8, :_method, :script_name

    attr_accessor :view_context, :options

    def initialize(view_context, opts = {})
      @view_context = view_context
      @options = opts

      # Next and previous view links should use the same params as the current view
      @params = @view_context.respond_to?(:params) ? @view_context.params : {}
      @params = @params.to_unsafe_h if @params.respond_to?(:to_unsafe_h)
      @params = @params.with_indifferent_access.except(*PARAM_KEY_BLACKLIST)

      # Add in any additional params the user passed in
      @params.merge!(@options.fetch(:params, {}))
    end

    def render(&block)
      view_context.render(
        partial: partial_name,
        locals: {
          passed_block: block,
          calendar: self,
          date_range: date_range,
          start_date: start_date,
          sorted_events: sorted_events
        }
      )
    end

    def td_classes_for(day)
      today = Date.current

      td_class = ["day"]
      td_class << "wday-#{day.wday}"
      td_class << "today" if today == day
      td_class << "past" if today > day
      td_class << "future" if today < day
      td_class << "start-date" if day.to_date == start_date.to_date
      td_class << "prev-month" if start_date.month != day.month && day < start_date
      td_class << "next-month" if start_date.month != day.month && day > start_date
      td_class << "current-month" if start_date.month == day.month
      td_class << "has-events" if sorted_events.fetch(day, []).any?

      td_class
    end

    def tr_classes_for(week)
      today = Date.current
      tr_class = ["week"]
      tr_class << "current-week" if week.include?(today)

      tr_class
    end

    def url_for_next_view
      view_context.url_for(@params.merge(start_date_param => (date_range.last + 1.day).iso8601))
    end

    def url_for_previous_view
      view_context.url_for(@params.merge(start_date_param => (date_range.first - 1.day).iso8601))
    end

    def date_range
      (start_date..(start_date + additional_days.days)).to_a
    end

    private

    def partial_name
      @options[:partial] || self.class.name.underscore
    end

    def attribute
      options.fetch(:attribute, :start_time).to_sym
    end

    def end_attribute
      options.fetch(:end_attribute, :end_time).to_sym
    end

    def start_date_param
      options.fetch(:start_date_param, :start_date).to_sym
    end

    def sorted_events
      @sorted_events ||= begin
        events = options.fetch(:events, []).reject { |e| e.send(attribute).nil? }.sort_by(&attribute)
        group_events_by_date(events)
      end
    end

    def group_events_by_date(events)
      events_grouped_by_date = Hash.new { |h, k| h[k] = [] }

      events.each do |event|
        event_start_date = event.send(attribute).to_date
        event_end_date = event.respond_to?(end_attribute) && !event.send(end_attribute).nil? ? event.send(end_attribute).to_date : event_start_date
        (event_start_date..event_end_date.to_date).each do |enumerated_date|
          events_grouped_by_date[enumerated_date] << event
        end
      end

      events_grouped_by_date
    end

    def start_date
      if options.has_key?(:start_date)
        options.fetch(:start_date).to_date
      else
        view_context.params.fetch(start_date_param, Date.current).to_date
      end
    end

    def end_date
      date_range.last
    end

    def additional_days
      options.fetch(:number_of_days, 4) - 1
    end
  end
end
