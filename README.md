Simple Calendar
===============

Simple Calendar is design to do one thing really really well: render a
calendar. It lets you render a calendar of any size. Maybe you want a
day view, a 4 day agenda, a week view, a month view, or a 6 week
calendar. You can do all of that with the new gem, just give it a range
of dates to render.

It doesn't depend on any ORM so you're free to use it with ActiveRecord,
Mongoid, any other ORM, or pure Ruby objects.

Thanks to all contributors for your wonderful help!

Installation
------------

Just add this into your Gemfile followed by a bundle install:

    gem "simple_calendar", "~> 1.0.0"

Usage
-----

Generating calendars is extremely simple with simple_calendar in version 1.0.

The first parameter is a symbol that looks up the current date in
`params`. If no date is found, it will use the current date.

In these examples, we're using `:start_date` which is the default.

### Month Calendar

You can generate a calendar for the month with the `month_calendar`
method.
This will use `params[:start_date]` to render the calendar.

```erb
<%= month_calendar :start_date do |day| %>
  <%= day %>
<% end %>
```

### Week Calendar

You can generate a week calendar with the `week_calendar` method.
This will use `params[:start_date]` to render the calendar.

```erb
<%= week_calendar :start_date, number_of_weeks: 2 do |day| %>
  <%= day %>
<% end %>
```

Setting `number_of_weeks` is optional and defaults to 1.

### Custom Length Calendar

You can generate calendars of any length by passing in the number of days you want to render.
This will use `params[:start_date]` to render the calendar.

```erb
<%= calendar :start_date, number_of_days: 4 do |day| %>
  <%= day %>
<% end %>
```

Setting `number_of_days` is optional and defaults to 4.

## Customizing The Calendar

You can change a couple of global options that will affect how the
calendars are generated:

```ruby
Time.zone = "Central Time (US & Canada)"
```

Setting `Time.zone` will make sure the calendar start days are correctly computed
in the right timezone. You can set this globally in your `application.rb` file or
if you have a User model with a time_zone attribute, you can set it on every request by using
a before_filter like the following example.

This code example uses [Devise](https://github.com/plataformatec/devise)'s
`current_user` and `user_signed_in?` methods to retrieve the user's timezone and set it for the duration of the request.
Make sure to change the `:user_signed_in?` and `current_user` methods if you are
using some other method of authentication.

```ruby
class ApplicationController < ActionController::Base
  before_filter :set_time_zone, if: :user_signed_in?

  private

    def set_time_zone
      Time.zone = current_user.time_zone
    end
end
```

You can also change the beginning day of the week. If you want to set
this globally, you can put this line in
`config/initializers/simple_calendar.rb`:

```ruby
Date.beginning_of_week = :sunday
```

Setting classes on the table and elements are pretty:

```ruby

<%= calendar :start_date,
  table: {class: "table table-bordered"},
  tr: {class: "row"},
  td: {class: "day"}, do |day| %>
<% end %>
```

This will set the class of `table table-bordered` on the `table` HTML
element.

Each of the `table`, `tr`, and `td`, options are passed directly to the
the `content_tag` method so each of them **must** be a hash.

### Custom Header Links

Each of the calendar methods will generate a header with links to the
previous and next views. The `month_calendar` also includes a header
that tells you the current month and year that you are viewing.

To change these, you can pass in the `prev_link`, `header`, and
`next_link` options into the calendar methods.

The default `month_calendar` look like this:

```erb
<%= month_calendar :start_date,
  prev_link: ->(range) { link_to raw("&laquo;"), param_name => range.first - 1.day },
  header: ->{ content_tag :span, "#{I18n.t("date.month_names")[start_date.month]} #{start_date.year}", class: "calendar-header" },
  next_link: ->(range) { link_to raw("&raquo;"), param_name => range.last + 1.day } do |day| %>

<% end %>
```

The `prev_link` option is a standard `link_to` that is a left arrow and
with the current url having `?start_date=2014-04-30` appended to it as
a date in the previous view of the calendar.

The `next_link` option is a standard `link_to` that is a right arrow and
with the current url having `?start_date=2014-06-01` appended to it as
a date in the next view of the calendar.

The `header` option is just a simple span tag with the month and year
inside of it.

If you wish to disable any of these partsof the header, just pass in
`false` and that will hide it:

```erb
<%= month_calendar :start_date, header: false do |day| %>
<% end %>
```


## Author

Chris Oliver <chris@gorails.com>

[https://gorails.com](https://gorails.com)

[@excid3](https://twitter.com/excid3)
