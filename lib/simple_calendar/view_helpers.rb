module SimpleCalendar
  module ViewHelpers

    def calendar(events, &block)
      selected_month = Date.civil((params[:year] || Time.zone.now.year).to_i, (params[:month] || Time.zone.now.month).to_i)
      current_date   = Date.today
      range          = build_range selected_month
      month_array    = build_month range

      draw_calendar(selected_month, month_array, current_date, events, block)
    end

    private

    def build_range(selected_month)
      start_date = selected_month.beginning_of_month
      start_date = start_date.sunday? ? start_date : start_date.beginning_of_week(:sunday)

      end_date   = selected_month.end_of_month
      end_date   = end_date.saturday? ? end_date : end_date.end_of_week(:sunday)

      date_range = (start_date..end_date).to_a
    end

    def build_month(date_range)
      month = []
      week  = []
      i     = 0

      date_range.each do |date|
        week << date
        if i == 6
          i = 0
          month << week
          week = []
        else
          i += 1
        end
      end

      month
    end

    # Renders the calendar table
    def draw_calendar(selected_month, month, current_date, events, block)
      tags = []

      content_tag(:table, :class => "table table-bordered table-striped calendar") do
        tags << month_header(selected_month)
        tags << content_tag(:thead, content_tag(:tr, I18n.t("date.abbr_day_names").collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))
        tags << content_tag(:tbody) do

          month.collect do |week|
            content_tag(:tr, :class => (week.include?(Date.today) ? "current-week week" : "week")) do

              week.collect do |date|
                tb_class = []
                tb_class << not_current_month = (date.month == selected_month.month ? "" : "not-currnet-month")
                tb_class << (Date.today == date ? "today day" : "day")

                content_tag(:td, :class => tb_class.join(" ")) do
                  content_tag(:div) do
                    divs = []

                    concat content_tag(:div, date.day.to_s)
                    divs << day_events(date, events).collect {|event| block.call(event) }
                    divs.join.html_safe
                  end #content_tag :div
                end #content_tag :td

              end.join.html_safe
            end #content_tag :tr

          end.join.html_safe
        end #content_tag :tbody

        tags.join.html_safe
      end #content_tag :table
    end

    # Returns an array of events for a given day
    def day_events(date, events)
      events.select { |e| e.start_time_column.to_date == date }
    end

    # Generates the header that includes the month and next and previous months
    def month_header(selected_month)
      content_tag :h2 do
        previous_month = selected_month.advance :months => -1
        next_month = selected_month.advance :months => 1
        tags = []

        tags << month_link("&laquo;".html_safe, previous_month, :class => "previous-month")
        tags << I18n.t("date.month_names")[selected_month.month]
        tags << month_link("&raquo;".html_safe, next_month, :class => "next-month")

        tags.join.html_safe
      end
    end

    # Generates the link to next and previous months
    def month_link(text, month, opts={})
      link_to(text, "#{simple_calendar_path}?month=#{month.month}&year=#{month.year}", opts)
    end

    # Returns the full path to the calendar
    # This is used for generating the links to the next and previous months
    def simple_calendar_path
      request.fullpath.split('?').first
    end
  end
end
