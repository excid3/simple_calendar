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

Generating calendars is extremely simple with simple_calendar now.

You can generate a calendar for the month just by passing in a given
date:

```erb
<%= month_calendar params[:start_date] do |day| %>
  <%= day %>
<% end %>
```

You can generate a week calendar by passing in a date in the week:

```erb
<%= week_calendar params[:start_date], number_of_weeks: 1 do |day| %>
  <%= day %>
<% end %>
```

Lastly you can generate calendars of any length by passing in the start
date and the number of days you want to render:

```erb
<%= calendar params[:start_date], number_of_days: 4 do |day| %>
  <%= day %>
<% end %>
```

