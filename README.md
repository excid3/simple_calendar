![travis ci](https://travis-ci.org/excid3/simple_calendar.svg?branch=master)

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
```ruby
gem "simple_calendar", "~> 2.0"
```

If you're using Bootstrap, the calendar should already have a border and
nice spacing for days.

Optionally, you can include the default stylesheet for the calendar in
your `app/assets/stylesheets/application.css` file:

```scss
*= require simple_calendar
```

Usage
-----

Generating calendars is extremely simple with simple_calendar.

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

To show the day of the month instead of the date, use `<%= date.day %>`

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

### Custom Parameter Name

You can pass in `start_date_param` to change the name of the parameter
in the URL for the current calendar view.

```erb
<%= calendar start_date_param: :my_date do |date| %>
  <%= date %>
<% end %>
```

### Custom Partial

You can set a different partial name for calendars by passing the partial path.

```erb
<%= calendar partial: 'products/calendar' do |date| %>
  <%= date %>
<% end %>
```

## Rendering Events

What's a calendar without events in it? There are two simple steps for creating
calendars with events.

The first step is to add the following to your model. We'll be using a
model called Meeting, but you can add this to any model or Ruby object.

Here's an example model:

```bash
# single day events
$ rails g scaffold Meeting name start_time:datetime

# multi-day events
$ rails g scaffold Meeting name start_time:datetime end_time:datetime
```

By default it uses `start_time` as the attribute name.  
**If you'd like to use another attribute other than start_time, just
pass it in as the `attribute`**

```erb
<%= month_calendar(attribute: :starts_at) do |date| %>
  <%= date %>
<% end %>
```

Optionally the `end_time` attribute can be used which enables multi-day event rendering.

**Just pass in the `attribute` and `end_attribute` options respectively**

```erb
<%= month_calendar(attribute: :start_date, end_attribute: :end_date) do |date| %>
  <%= date %>
<% end %>
```

**If you already have a model with a start time attribute called something other than `start_time` or accesses it through a relationship, you can alias the attribute by defining a `start_time` method in the my_model.rb file and not have to specify it separately as in the above example**
```ruby
class MyModel
    ## Other code related to your model lives here

    def start_time
        self.my_related_model.start ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
    end
end
```

In your controller, query for these meetings and store them in an instance
variable. Normally you'll want to search for the ones that only show up
inside the calendar view (for example, you may only want to grab the events for
the current month).

We'll just load up all the meetings for this example.

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

There are a handful of configuration options that you can use in
simple_calendar.

### Customizing Views

You can customize the layouts for each of the calendars by running the
generators for simple_calendar:

```bash
$ rails g simple_calendar:views
```

This will generate a folder in app/views called simple_calendar that you
edit to your heart's desire.

### Time Zones

Setting `Time.zone` will make sure the calendar start days are correctly computed
in the right timezone. You can set this globally in your `application.rb` file or
if you have a User model with a time_zone attribute, you can set it on every request by using
a before_action like the following example.

This code example uses [Devise](https://github.com/plataformatec/devise)'s
`current_user` and `user_signed_in?` methods to retrieve the user's timezone and set it for the duration of the request.
Make sure to change the `:user_signed_in?` and `current_user` methods if you are
using some other method of authentication.

```ruby
class ApplicationController < ActionController::Base
  before_action :set_time_zone, if: :user_signed_in?

  private

    def set_time_zone
      Time.zone = current_user.time_zone
    end
end
```

If you want to set the time zone globally, you can set the following in
`config/application.rb`:

```ruby
config.time_zone = 'Central Time (US & Canada)'
```

### Beginning Of Week

You can also change the beginning day of the week by setting
`Date.beginning_of_week` in a `before_action` just like in the previous
example. If you want to set this globally, you can put this line in
`config/application.rb`:

```ruby
config.beginning_of_week = :sunday
```

### Custom CSS Classes

Setting classes on the table and elements are pretty easy.

simple_calendar comes with a handful of useful classes for each day in
the calendar that you can use:

```scss
.simple-calendar {
  .day {}

  .wday-0 {}
  .wday-1 {}
  .wday-2 {}
  .wday-3 {}
  .wday-4 {}
  .wday-5 {}
  .wday-6 {}

  .today {}
  .past {}
  .future {}

  .start-date {}

  .prev-month {}
  .next-month { }
  .current-month {}

  .has-events {}
}
```

Just paste this into a CSS file and add your styles and they will be
applied to the calendar. All of these classes are inside of the
simple-calendar class so you can scope your own classes with similar
names.

### Custom Header Title And Links

Header and title links are easily adjusted by generating views and
modifying them inside your application.

For example, if you'd like to use abbreviated month names, you can modify
the views from this:

```erb
<%= t('date.month_names')[start_date.month] %> <%= start_date.year %>
```

To

```erb
<%= t('date.abbr_month_names')[start_date.month] %> <%= start_date.year %>
```

Your calendar will now display "Sep 2015" instead of "September 2015" at
the top! :)

### AJAX Calendars

Rendering calendars that update with AJAX is pretty simple. You'll need
to wrap your calendar in a div, overwrite the `next_link` and `previous_link` options, and setup your
controller to respond to JS requests. The response can simply replace
the HTML of the div with the newly rendered calendar.

Take a look at **[excid3/simple_calendar-ajax-example](https://github.com/excid3/simple_calendar-ajax-example)** to see how it is done.


## Custom Calendars

The three main calendars available should take care of most of your
needs, but simple_calendar makes it easy to create completely custom
calendars (like maybe you only want business weeks).

If you'd like to make a completely custom calendar, you can create a new
class that inherits from `SimpleCalendar::Calendar`. The name you give
it will correspond to the name of the template it will try to render.


The main method you'll need to implement is the `date_range` so that
your calendar can have a custom length.

```ruby
class SimpleCalendar::BusinessWeekCalendar < SimpleCalendar::Calendar
  private

    def date_range
      beginning = start_date.beginning_of_week + 1.day
      ending    = start_date.end_of_week - 1.day
      (beginning..ending).to_a
    end
end
```

To render this in the view, you can do:

```erb
<%= SimpleCalendar::BusinessWeekCalendar.new(self, {}).render do |date| %>
  <%= date %>
<% end %>
```

And this will render the
`app/views/simple_calendar/_business_week_calendar.html.erb` partial.

You can copy one of the existing templates to use for the partial for
your new calendar.

## View Specs and Tests

If you're running view specs against views with calendars, you may run into route generation errors like the following:

```
Failure/Error: render
ActionView::Template::Error:
  No route matches {:action=>"show", :controller=>"controller_name", :start_date=>Sun, 29 Mar 2015}
```

If so, you can stub out the appropriate method like so (rspec 3 and up):

```
expect_any_instance_of(SimpleCalendar::Calendar).to receive(:link_to).at_least(:once).and_return("")
```

With modifications as appropriate.

## TODO

- Rspec tests for Calendar
- Rspec tests for MonthCalendar
- Rspec tests for WeekCalendar

## Author

Chris Oliver <chris@gorails.com>

[https://gorails.com](https://gorails.com)

[@excid3](https://twitter.com/excid3)

## Support

Need help
