module SimpleCalendar
  module ViewHelpers
    def calendar(events)
      day = Date.civil((params[:year] || Time.zone.now.year).to_i, (params[:month] || Time.zone.now.month).to_i)

      content_tag :table, :class => "bordered-table calendar" do
        month_header(day) + day_header + body(day, events)
      end
    end

    def start_date(date)
      start_date = date.beginning_of_month
      start_date = start_date.beginning_of_week.advance(:days => -1) unless start_date.sunday?
      start_date
    end

    def end_date(date)
      end_date = date.end_of_month
      end_date = end_date.advance(:days => 1).end_of_week if end_date.sunday?
      end_date
    end

    def month_header(day)
      content_tag :h2 do
        previous_month = day.advance :months => -1
        next_month = day.advance :months => 1
        tags = []
        tags << link_to("<", calendar_path(:month => previous_month.month, :year => previous_month.year))
        tags << day.strftime("%B %Y")
        tags << link_to(">", calendar_path(:month => next_month.month, :year => next_month.year))
        tags.join.html_safe
      end
    end

    def day_header
      content_tag :thead do
        content_tag :tr do
          I18n.t(:"date.abbr_day_names").map{ |day| content_tag :th, day }.join.html_safe
        end
      end
    end

    def body(day, events)
      current_date = start_date(day).dup

      content_tag :tbody do
        weeks = []
        while current_date < end_date(day)
          weeks << content_tag(:tr) do
            tags = []
            while not current_date.saturday?
              tags << day(current_date, events)
              current_date = current_date.tomorrow
            end
            tags << day(current_date, events)
            current_date = current_date.tomorrow
            tags.join.html_safe
          end
        end
        weeks.join.html_safe
      end
    end

    def day(date, events)
      content_tag :td do
        events = day_events(date, events)
        tags = [content_tag(:div, date.day, :class => "day")]
        tags += events.map { |e| content_tag(:div, e.title_column) } unless events.empty?
        tags.join.html_safe
      end
    end

    def day_events(date, events)
      events.select { |e| e.start_time_column.to_date == date }
    end
  end
end
