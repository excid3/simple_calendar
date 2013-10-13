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

You can use ruby's `..` or `...` to create ranges
that are inclusive or exclusive of the last value to make ranges easier
to manage.

```erb
<h1>6 week calendar</h1>
<% start_day  = Time.zone.now.to_date %>
<% end_day    = start_day + 6.weeks %>
<% date_range = start_day...end_day %>

<%= calendar date_range, table: {class: "table"} do |day| %>
  <%= day %>
<% end %>


<h1>Month calendar</h1>
<% start_day  = Time.zone.now.beginning_of_month.beginning_of_week.to_date %>
<% end_day    = Time.zone.now.end_of_month.end_of_week.to_date %>
<% date_range = start_day..end_day %>

<%= calendar date_range, table: ->{ {class: "table"} } do |day| %>
  <%= day %>
<% end %>



<h1>Week calendar</h1>
<% start_day  = Time.zone.now.to_date %>
<% end_day    = start_day + 6.days %>
<% date_range = start_day..end_day %>

<%= calendar date_range, table: {class: "table"} do |day| %>
  <%= day %>
<% end %>



<h1>4 day agenda calendar</h1>
<% start_day  = Time.zone.now.to_date %>
<% end_day    = start_day + 3.days %>
<% date_range = start_day..end_day %>

<%= calendar date_range, table: ->{ {class: "table"} }, tr: {class: "tr"}, td: :day_class do |day| %>
  <%= day %>
<% end %>
```
