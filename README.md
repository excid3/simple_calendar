Simple Calendar
===============

Simple Calendar is designed to do one thing really really well: render a
calendar. It lets you render a calendar of any size. Maybe you want a
day view, a 4 day agenda, a week view, a month view, or a 6 week
calendar. You can do all of that with the new gem, just give it a range
of dates to render.

It doesn't depend on any ORM so you're free to use it with ActiveRecord,
Mongoid, any other ORM, or pure Ruby objects.

Thanks to all contributors for your wonderful help!

![calendar](https://s3.amazonaws.com/f.cl.ly/items/1T0t1s0W212d28282V2M/Screen%20Shot%202013-03-28%20at%209.44.49%20AM.png)

Installation
------------

Just add this into your Gemfile followed by a bundle install:

    gem "simple_calendar", "~> 1.1.0"

Usage
-----

Generating calendars is extremely simple with simple_calendar in version 1.1.

The first parameter is a symbol that looks up the current date in
`params`. If no date is found, it will use the current date.

In these examples, we're using `:start_date` which is the default.

### Month Calendar

You can generate a calendar for the month with the `month_calendar`
method.

```erb
<%= month_calendar do |date| %>
  <%= date %>
<% end %>
```

### Week Calendar

You can generate a week calendar with the `week_calendar` method.

```erb
<%= week_calendar number_of_weeks: 2 do |date| %>
  <%= date %>
<% end %>
```

Setting `number_of_weeks` is optional and defaults to 1.

### Custom Length Calendar

You can generate calendars of any length by passing in the number of days you want to render.

```erb
<%= calendar number_of_days: 4 do |date| %>
  <%= date %>
<% end %>
```

Setting `number_of_days` is optional and defaults to 4.

## Rendering Events

What's a calendar without events in it? There are two simple steps for creating
calendars with events.

The first step is to add the following to your model. We'll be using a
model called Meeting, but you can add this to any model or Ruby object.

Here's an example model:

```bash
rails g scaffold Meeting name starts_at:datetime
```

We use the `has_calendar` method to tell simple_calendar how to filter
and sort the meetings on the different calendar days. This should be the
start date/time of your meeting. By default it uses `starts_at` as the
attribute name.

```ruby
class Meeting < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar

  # Or set a custom attribute for simple_calendar to sort by
  # has_calendar :attribute => :your_starting_time_column_name
end
```

In your controller, query for these meetings and store them in an instance
variable. We'll just load up all the meetings for this example.

```ruby
def index
  @meetings = Meeting.all
end
```

Then in your view, you can pass in the `events` option to render. The
meetings will automatically be filtered out by day for you.

```erb
<%= month_calendar events: @meetings do |date, meetings| %>
  <%= date %>

  <% meetings.each do |meeting| %>
    <div>
      <%= meeting.name %>
    </div>
  <% end %>
<% end %>
```

If you pass in objects that don't respond to the attribute method (like
starts_at), then all the meetings will be yielded each day. This lets you
do custom filtering however you want.

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
On the other hand, you can always pass a ``ActiveSupport::TimeZone`` object as an option to avoid possible timezone pollution:

```erb
<%= calendar timezone: ActiveSupport::TimeZone.new('Taipei') do |date, events| %>
<% end %>
```

If you want to set the time zone globally, you can set the following in
`config/application.rb`:

```ruby
config.time_zone = 'Central Time (US & Canada)'
```

You can also change the beginning day of the week by setting
`Date.beginning_of_week` in a `before_filter` just like in the previous
example. If you want to set this globally, you can put this line in
`config/application.rb`:

```ruby
config.beginning_of_week = :sunday
```

Setting classes on the table and elements are pretty easy.

Each of the options are passed directly to the
the `content_tag` method so each of them **must** be a hash.

```ruby

<%= calendar table: {class: "table table-bordered"}, tr: {class: "calendar-row"}, td: {class: "day"}, do |date| %>
<% end %>
```

This will set the class of `table table-bordered` on the `table` HTML
element.

### Custom Day Classes

`td` is an option for setting the options on the td content tag that is
generated. By default, simple_calendar renders the following classes for
any given day in a calendar:


```ruby
td_class = ["day"]
td_class << "today"  if today == current_calendar_date
td_class << "past"   if today > current_calendar_date
td_class << "future" if today < current_calendar_date
td_class << "prev-month"    if start_date.month != current_calendar_date.month && current_calendar_date < start_date
td_class << "next-month"    if start_date.month != current_calendar_date.month && current_calendar_date > start_date
td_class << "current-month" if start_date.month == current_calendar_date.month
td_class << "wday-#{current_calendar_date.wday.to_s}"
```

You can set your CSS styles based upon these if you want to highlight
specific days or types of days. If you wish to override this
functionality, just set the `tr` option to a lambda that accepts two
dates and returns a hash. The hash will be passed in directly to the
content_tag options. If you wish to set a class or data attributes, just
set them as you normally would in a content_tag call.

```erb
<%= month_calendar td: ->(start_date, current_calendar_date) { {class: "calendar-date", data: {day: current_calendar_date}} } do |day| %>
<% end %>
```

This generate each day in the calendar like this:

```html
<td class="calendar-date" data-day="2014-05-11">
</td>
```

Instead of writing the lambdas inline, a cleaner approach is to write a
helper that returns a lambda. You can duplicate the following example by
adding this to one of your helpers:

```ruby
def month_calendar_td_options
  ->(start_date, current_calendar_date) {
    {class: "calendar-date", data: {day: current_calendar_date}}
  }
end
```

And then your view would use `month_calendar_td_options` as the value.

```erb
<%= month_calendar td: month_calendar_td_options do |date| %>
<% end %>
```

### Custom Header Title And Links

Each of the calendar methods will generate a header with links to the
previous and next views. The `month_calendar` also includes a header
with a title that tells you the current month and year that you are viewing.

To change these, you can pass in the `previous_link`, `title`, and
`next_link` options into the calendar methods.

**Use a method in your helpers to return a lambda instead of writing
them inline like these examples so your views are cleaner.**

* `title` option is a lambda that shows at the top of the calendar. For
month calendars, this is the Month and Year (May 2014)

```erb
<%= calendar title: ->(start_date) { content_tag :span, "#{I18n.t("date.month_names")[start_date.month]} #{start_date.year}", class: "calendar-title" } do |date, events| %>
<% end %>
```

* `previous_link` option is a standard `link_to` that is a left arrow and
with the current url having `?start_date=2014-04-30` appended to it as
a date in the previous view of the calendar.

```erb
<%= month_calendar previous_link: ->(param, date_range) { link_to raw("&laquo;"), {param => date_range.first - 1.day} } do |date, events| %>
<% end %>
```

* `next_link` option is a standard `link_to` that is a right arrow and
with the current url having `?start_date=2014-06-01` appended to it as
a date in the next view of the calendar.

```erb
<%= calendar next_link: ->(param, date_range) { link_to raw("&raquo;"), {param => date_range.last + 1.day} } do |date, events| %>
<% end %>
```

* `header` lets you add options to the header tag

```erb
<%= calendar header: {class: "calendar-header"} do |date, events| %>
<% end %>
```

* `thead` allows you to customize the table headers. These are the
  abbreviated day names by default (Sun Mon Tue Wed).

You can disable the `thead` line if you like by passing in `false`.

```erb
<%= calendar thead: false do |date, events| %>
<% end %>
```

* `day_names` lets you customize the day names in the `thead` row.

If you want to use full day names instead of the abbreviated ones in the
table header, you can pass in the `day_names` option which points to a
validate I18n array.

```erb
<%= calendar day_names: "date.day_names" do |date, events| %>
<% end %>
```

Which renders:

```html
<thead>
  <tr>
    <th>Sunday</th>
    <th>Monday</th>
    <th>Tuesday</th>
    <th>Wednesday</th>
  </tr>
</thead>
```

By default we use the `date.abbr_day_names` translation to have shorter
header names.

```erb
<%= calendar day_names: "date.abbr_day_names" do |date, events| %>
<% end %>
```

This renders:

```html
<thead>
  <tr>
    <th>Sun</th>
    <th>Mon</th>
    <th>Tue</th>
    <th>Wed</th>
  </tr>
</thead>
```

### AJAX Calendars

Rendering calendars that update with AJAX is pretty simple. You'll need
to wrap your calendar in a div, overwrite the `next_link` and `previous_link` options, and setup your
controller to respond to JS requests. The response can simply replace
the HTML of the div with the newly rendered calendar.

Take a look at **[excid3/simple_calendar-ajax-example](https://github.com/excid3/simple_calendar-ajax-example)** to see how it is done.

## TODO

- Multi-day events?

## Author

Chris Oliver <chris@gorails.com>

[https://gorails.com](https://gorails.com)

[@excid3](https://twitter.com/excid3)
