require 'rails'

module SimpleCalendar
  class Calendar
    def initialize(view_context, opts={})
    end

    def render(block)
    end

    def render_header
    end

    def render_table
    end

    def render_weeks
    end

    def render_week(week)
    end

    def param_name
    end

    def events_for_date(current_date)
    end

    def default_previous_link
    end

    def default_title
    end

    def default_next_link
    end

    def default_thead
    end

    def start_date
    end

    def date_range
    end

    def default_td_classes
    end

    def get_option(name, *params)
    end
  end
end
