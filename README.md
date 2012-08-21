Simple Calendar
===============

This is a small Rails 3.x gem for creating a quick and clean table calendar.
Theming is up to you, but it works nicely with Twitter Bootstrap.

Thanks to Josh Chernoff for an early rewrite of the calendar generation
code.

Installation
------------

Just add this into your Gemfile followed by a bundle install:

    gem "simple_calendar", "~> 0.0.5"

Usage
-----

####Model

Here we have a model called Event with the start_time attribute that we
will be using with simple_calendar.

    class Event < ActiveRecord::Base
      has_calendar
    end

has_calendar has options that can be passed to it for configuration:

    has_calendar :start_time => :my_start_column

The `start_time` option is the field for the start time of the event. This will use
`my_start_column` to determine which day to render the event on.

####Views

We query the events we want to display as usual, and then render the
calendar in the view like so:

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
    :prev_text         # previous month link text, default: &laquo;
    :next_text         # next month link text, default: &raquo;

CSS
---

You will probably want to customize the height of the calendar so that
all the rows are the same. You can do this by adding the following line
to your css:

    .calendar td { height: 100px; width: 14.28%; }

By default simple_calendar will set the calendar to use .bordered-table
and .calendar classes.

TODO
====

* Add query helpers to grab events for a current month and the days into
  the next and previous months for efficiency
* Customizable starting day of week
* More customization?
