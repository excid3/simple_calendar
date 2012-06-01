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
      start_date     = selected_month.beginning_of_month
      start_date     = start_date.sunday? ? start_date : start_date.beginning_of_week.advance(:days => -1)

      end_date       = selected_month.end_of_month
      end_date       = end_date.sunday? ? end_date : end_date.advance(:days => 1).end_of_week 
      date_range     = (start_date..end_date).to_a   

    end 

    def build_month(date_range)
      month          = []
      week           = []
      i              = 0
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
      return month
    end

    def draw_calendar(selected_month, month, current_date, events, block)

      tags = []

      content_tag(:table, :class => "table table-bordered table-striped") do
        
        tags << month_header(selected_month)

        tags << content_tag(:thead, content_tag(:tr, I18n.t("date.abbr_day_names").collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))

        tags << content_tag(:tbody) do 

          month.collect do |week| 

            content_tag(:tr, :class => (week.include?(Date.today) ? "current-week week" : "week")) do              

              week.collect do |date| 

                content_tag(:td, :class => "day") do

                  content_tag(:div, :class => (Date.today == current_date ? "today" : nil)) do

                    divs = []

                    divs << content_tag(:div, date.day.to_s)
                    
                    divs << day_events(date, events).collect do |event|
                      block.call(event)
                    end

                    divs.join.html_safe

                  end #content_tag :div
                end #content_tag :td
              end.join.html_safe
            end #content_tag :tr
          end.join.html_safe
        end #content_tag :tbody 
        tags.join.html_safe
      end #content_tag :table
    end #draw_calendar

    def day_events(date, events)
      events.select { |e| e.start_time_column.to_date == date }
    end

    def month_header(selected_month)
          content_tag :h2 do
            previous_month = selected_month.advance :months => -1
            next_month = selected_month.advance :months => 1
            tags = []
            tags << link_to("<", request.fullpath.split('?').first + "?month=#{previous_month.month}&year=#{previous_month.year}")
            tags << selected_month.strftime("%B %Y")
            tags << link_to(">", request.fullpath.split('?').first + "?month=#{next_month.month}&year=#{next_month.year}")
            tags.join.html_safe
          end
        end
  end
end
