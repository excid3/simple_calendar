module SimpleCalendar
  class Calendar
    delegate :capture, :concat, :content_tag, :link_to, :params, :raw, :safe_join, to: :view_context

    attr_reader :block, :events, :options, :view_context

    def initialize(view_context, opts={})
      @view_context = view_context
      @events       = opts.delete(:events) { [] }
      @timezone     = opts.fetch(:timezone, Time.zone)

      opts.reverse_merge!(
        header: {class: "calendar-header"},
        previous_link: default_previous_link,
        title: default_title,
        next_link: default_next_link,
        td: default_td_classes,
        thead: default_thead,
      )

      @options      = opts
    end

    def render(block)
      @block = block

      capture do
        concat render_header
        concat render_table
      end
    end

    def render_header
      capture do
        content_tag :header, get_option(:header) do
          concat get_option(:previous_link, param_name, date_range)
          concat get_option(:title, start_date)
          concat get_option(:next_link, param_name, date_range)
        end
      end
    end

    def render_table
      content_tag :table, get_option(:table)  do
        capture do
          concat get_option(:thead, date_range.to_a.slice(0, 7))
          concat content_tag(:tbody, render_weeks, get_option(:tbody))
        end
      end
    end

    def render_weeks
      capture do
        date_range.each_slice(7) do |week|
          concat content_tag(:tr, render_week(week), get_option(:tr, week))
        end
      end
    end

    def render_week(week)
      results = week.map do |day|
        content_tag :td, get_option(:td, start_date, day) do
          block.call(day, events_for_date(day))
        end
      end
      safe_join results
    end

    def param_name
      @param_name ||= options.fetch(:param_name, :start_date)
    end

    def events_for_date(current_date)
      if events.any? && events.first.respond_to?(:simple_calendar_start_time)
        events.select do |e|
          current_date == e.send(:simple_calendar_start_time).in_time_zone(@timezone).to_date
        end.sort_by(&:simple_calendar_start_time)
      else
        events
      end
    end

    def default_previous_link
      ->(param, date_range) { link_to raw("&laquo;"), param => date_range.first - 1.day }
    end

    def default_title
      ->(start_date) {  }
    end

    def default_next_link
      ->(param, date_range) { link_to raw("&raquo;"), param => date_range.last + 1.day }
    end

    def default_thead
      ->(dates) {
        content_tag(:thead) do
          content_tag(:tr) do
            capture do
              dates.each do |date|
                concat content_tag(:th, I18n.t(options.fetch(:day_names, "date.abbr_day_names"))[date.wday])
              end
            end
          end
        end
      }
    end

    def start_date
      @start_date ||= (get_option(:start_date) || params[param_name] || Time.zone.now).to_date
    end

    def date_range
      @date_range ||= begin
                        number_of_days = options.fetch(:number_of_days, 4) - 1
                        start_date..(start_date + number_of_days.days)
                      end
    end

    def default_td_classes
      ->(start_date, current_calendar_date) {
        today = Time.zone.now.to_date
        td_class = ["day"]
        td_class << "today"  if today == current_calendar_date
        td_class << "past"   if today > current_calendar_date
        td_class << "future" if today < current_calendar_date
        td_class << "prev-month"    if start_date.month != current_calendar_date.month && current_calendar_date < start_date
        td_class << "next-month"    if start_date.month != current_calendar_date.month && current_calendar_date > start_date
        td_class << "current-month" if start_date.month == current_calendar_date.month
        td_class << "wday-#{current_calendar_date.wday.to_s}"
        td_class << "has-events" if events_for_date(current_calendar_date).any?

        { class: td_class.join(" ") }
      }
    end

    def get_option(name, *params)
      option = options[name]
      case option
      when Hash
        option
      else
        option.respond_to?(:call) ? option.call(*params) : option
      end
    end
  end
end
