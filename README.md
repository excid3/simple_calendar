Simple Calendar
===============

This is a small Rails 3.2 gem for creating a quick and clean table calendar.
Theming is up to you, but it works nicely with Twitter Bootstrap. It's
compatible with pure Ruby classes, ActiveRecord, Mongoid, and any other
ORM.

Thanks to Josh Chernoff and all other contributors.

Installation
------------

Just add this into your Gemfile followed by a bundle install:

    gem "simple_calendar", "~> 0.1.1"

Usage
-----

#### Model

SimpleCalendar will look for a method on your model called `start_time`.
This is used to determine the day and time of the event. This should be
a `DateTime` object or at least respond similarly.

The simplest way to use SimpleCalendar is to have an attribute on your
model called `start_time` and you won't need to make any changes to your
model at all. For example, I used `rails g model Event name:string
start_time:datetime` to generate this class:

```ruby
class Event < ActiveRecord::Base
  attr_accessible :name, :start_time
end
```

If you don't have an attribute called `start_time` on your model, you
can simply delegate like so:

```ruby
class Event < ActiveRecord::Base
  attr_accessible :name, :event_start_time

  def start_time
    event_start_time
  end
end
```

As long as `start_time` returns a `DateTime` object, you're good to go.
This means SimpleCalendar is now compatible with any class, whether it's
ORM backed like ActiveRecord, Mongoid, or it's just a pure Ruby class.
(Yay!)

##### Querying

SimpleCalendar uses `params[:month]` and `params[:year]` to determine
which month of the calendar to render. You can use these to make your
database queries more efficient.

#### Views

SimpleCalendar just accepts an array of events and a block. The block
will be executed for each event so you can provide your own logic for
displaying the events.

Here's an example that uses SimpleCalendar to simply render a link to
each event on its own line inside the table. You would simply query for
the `@events` as discussed above in the querying section.

    <%= calendar @events do |event| %>
      <div><%= link_to event.title, event %></div>
    <% end %>

When the calendar is rendering, it yields to the block to allow you to
render whatever you like for the item. In this example, I use the title
attribute on the event with a link to the event.

You may even pass options to calendar renderer to customize it's behavior

    <%= calendar @events, {:prev_text=>"prev", :next_text=>"next"} do |event| %>
      <div><%= link_to event.title, event %></div>
    <% end %>

This time calendar will use prev and next as labels for previous and next month links (which are normally set to &amp;laquo; (&laquo;) and &amp;raquo; (&raquo;)

Possible options:

    :year	           # current year, default: from params or current year
    :month		       # current month, default: from params or current month
    :prev_text       # previous month link text, default: &laquo;
    :next_text       # next month link text, default: &raquo;
    :start_day       # starting day of week, default: :sunday

CSS
---

You will probably want to customize the height of the calendar so that
all the rows are the same heights and widths. You can do this by adding
the following line to your css:

    .calendar td { height: 100px; width: 14.28%; }

By default simple_calendar will set the calendar to use .bordered-table
and .calendar classes.
