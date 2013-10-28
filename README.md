skyscanner
==========

A Ruby wrapper for the Skyscanner API.


Installation
------------

**With Bundler**

In your Gemfile, add the following line

    gem 'skyscanner', :require => 'skyscanner'

**Without Bundler**

    gem install skyscanner

Usage
-----

At the moment the interface is very simple and it only supports the Browse Cache Service API. Feel free to submit pull requests for more features.

Each of the four endpoints can be accessed with a class method reflecting the endpoint's name.

    Skyscanner::Connection.browse_dates
    Skyscanner::Connection.browse_grid
    Skyscanner::Connection.browse_routes
    Skyscanner::Connection.browse_quotes
    Skyscanner::Connection.site_redirect

Options can be passed in a hash to these methods and they will be included in the request.

    ## Example from: http://www.skyscanneraffiliate.net/portal/en-GB/US/BrowseCache/BrowseQuotes
    Skyscanner::Conneciton.browse_quotes({ :country => "GB", :curency => "GBP", :locale => "en-GB", :originPlace => "UK", :destinationPlace => "anywhere", :outboundPartialDate => "anytime", :inboundPartialDate => "anytime" })
    # => GET http://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/GB/GBP/en-GB/UK/anywhere/anytime/anytime?apiKey=prtl6749387986743898559646983194

There are a number of class level options that can be overridden.

    Skyscanner::Connection.adapter          # the Faraday adapter to use (default: :net_http)
    Skyscanner::Connection.logger           # a Logger object for logging requests (default: nil)
    Skyscanner::Connection.protocol         # http or https (default: :http)
    Skyscanner::Connection.response_format  # ruby, json, jsonp or xml (default: ruby)
    Skyscanner::Connection.url              # partners.api.skyscanner.net/apiservices/
    Skyscanner::Connection.version          # v.10
    
Example:

    Skyscanner::Connection.protocol
    # => :http
    Skyscanner::Connection.protocol = :https
    # => :https

These options can also be overridden during instantiation of a Skyscanner::Connection

    @secure = Skyscanner::Connection.new({:protocol => :https})


Copyright
---------

Made for Soundtravel (http://soundtravel.co/).

Copyright (c) 2013 Alex Beregszaszi. See LICENSE for details.

Based on the SeatGeek Ruby API (https://github.com/bluefocus/seatgeek/) which is:
Copyright (c) 2012 Dan Matthews / Ticket Evolution ([http://ticketevolution.com](http://ticketevolution.com))
