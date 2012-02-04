module SimpleCalendar
  module ModelAdditions
    def has_calendar(options={})
      config = { :title => "title", :scope => "1 = 1", :top_of_list => 1}
      config.update(options) if options.is_a?(Hash)

      class_eval <<-EOV
        def title_column
          #{config[:title]}
        end
      EOV
    end
  end
end

