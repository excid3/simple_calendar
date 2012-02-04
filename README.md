Simple Calendar
===============

This is a small gem for creating a quick and clean table calendar.
Theming is up to you, but it works nicely with Twitter Bootstrap.

Installation
------------

Just add this into your Gemfile followed by a bundle install:

    gem "simple_calendar", "~> 0.0.1"

Usage
-----

Here we have a model called Event with the start_time attribute that we
will be using with simple_calendar.

    class Event < ActiveRecord::Base
      has_calendar
    end

We query the events we want to display as usual, and then render the
calendar in the view like so:

    <%= calendar @events %>

has_calendar has options that can be passed to it for configuration:

    has_calendar :title => :whatever

    def whatever
      title + " ohai"
    end
