require "rails"

module SimpleCalendar
  class Calendar
    PARAM_KEY_BLACKLIST = :authenticity_token, :commit, :utf8, :_method, :script_name

    # Keys url_for treats as URL options instead of query params. The built-in links don't
    # need these dropped (see url_for_date), but custom calendars that copied the old
    # `url_for(@params.merge(...))` override pass @params straight to url_for, so they're
    # left out of @params to keep those links from being pointed at another host, etc.
    URL_OPTION_KEYS = :host, :protocol, :port, :subdomain, :domain, :tld_length,
      :trailing_slash, :anchor, :params, :only_path, :original_script_name,
      :relative_url_root, :user, :password, :use_route, :_recall

    attr_accessor :view_context, :options

    def initialize(view_context, options = {}, &block)
      @view_context = view_context
      @locals = options.delete(:locals) || {}
      @options = options
      @block = block

      # Next and previous view links should use the same params as the current view
      @request_params = @view_context.respond_to?(:params) ? @view_context.params : {}
      @request_params = @request_params.to_unsafe_h if @request_params.respond_to?(:to_unsafe_h)
      @request_params = @request_params.with_indifferent_access.except(*PARAM_KEY_BLACKLIST)

      # Params passed in by the developer are trusted, so they're allowed to be url_for options
      @calendar_params = @options.fetch(:params, {}).to_h.symbolize_keys

      # Nothing in here uses @params anymore, but custom calendars still build their own links from it
      @params = @request_params.except(*URL_OPTION_KEYS).merge(@calendar_params)
    end

    def render_in(view_context, &block)
      @block = block
      view_context.render(
        partial: partial_name,
        locals: locals
      )
    end

    def locals(&block)
      @locals.merge(
        passed_block: @block,
        calendar: self,
        date_range: date_range,
        start_date: start_date,
        sorted_events: sorted_events
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
      url_for_date(date_range.last + 1.day)
    end

    def url_for_previous_view
      url_for_date(date_range.first - date_range.count.days)
    end

    def url_for_today_view
      url_for_date(Time.current.to_date)
    end

    # Only routing params and params passed in by the developer are given to url_for as
    # options. Everything else from the request goes under `params:`, which url_for always
    # treats as query params, so no request param can be read as a URL option. Route
    # segments named like a URL option (say `servers/:host`) are left to url_for, which
    # fills them in from the current request as path segments.
    def url_for_date(date)
      url_options = path_parameters.except(*URL_OPTION_KEYS).merge(@calendar_params).merge(start_date_param => date.iso8601)
      view_context.url_for(url_options.merge(params: @request_params.except(*path_parameters.keys, *url_options.keys)))
    end

    def date_range
      (start_date..(start_date + additional_days.days)).to_a
    end

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
        events = Array.wrap(options[:events]).reject { |e| e.send(attribute).nil? }.sort_by(&attribute)
        group_events_by_date(events)
      end
    end

    def sorted_events_for(day)
      Array.wrap(sorted_events[day])
    end

    def group_events_by_date(events)
      events_grouped_by_date = Hash.new { |h, k| h[k] = [] }

      events.each do |event|
        event_start_date = event.send(attribute).to_date
        event_end_date = (event.respond_to?(end_attribute) && !event.send(end_attribute).nil?) ? event.send(end_attribute).to_date : event_start_date
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
        start_date_from_params || Date.current
      end
    end

    def end_date
      date_range.last
    end

    def additional_days
      options.fetch(:number_of_days, 4) - 1
    end

    private

    def path_parameters
      view_context.try(:request)&.path_parameters || {}
    end

    def start_date_from_params
      view_context.params[start_date_param].try(:to_date)
    rescue ArgumentError # Date::Error inherits from ArgumentError
      nil
    end
  end
end
