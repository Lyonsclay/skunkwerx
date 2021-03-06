![Skunkwerx Logo](app/assets/images/Skunkwerx\ Logo.jpg)

[Skunkwerx Performance](http://www.skunkwerx-performance.com/) Complete specialized care for your TDI diesel powered VW or Audi now on the web.

[![Build Status](https://travis-ci.org/Lyonsclay/skunkwerx.svg?branch=master)](https://travis-ci.org/Lyonsclay/skunkwerx)

Developer: [Lyonsclay](http://wonkitnow.tumblr.com).

Maintenance free solutions:)

* [Built With](#built_with)

* [Introduction](#introduction)

* [Installation](#installation)

* [Gems](#gems)

* [Styles](#styles)

* [Debugging](#debugging)

* [Conclusion](#conclusion)

* [Resources](#resources)

## Built With

Ruby (2.1.1)

Rails (4.0.2)

## Introduction

This app has been built for ***Skunkwerx Performance Automotive LLC***. It serves the purpose of providing a basic customer interface for arranging automotive service and web sales for products related to performance enhancement.

Building this app has been opportunity to practice skills I have learned at **[Dev Bootcamp](http://devbootcamp.com/learn-more/)** Chicago. In principal I have opted for as many hand made solutions as possible. I tried to cut down on the number of external dependecies and tried to focus on learning root technology and not how to use specific gems. When that didn't seem advisable I used gems or frameworks that are high profile, proven solutions.

I created an extensive admin portal encoded in it's own namespace. This is a custom built solution that has high integration with **[FreshBooks](http://www.freshbooks.com/index-st.php)** accounting and a scraper that gathers products from a partner website and includes them in Skunkwerx listed products.

All products listed by Skunkwerx are backed by the Freshbooks database and integration with the Skunkwerx PostgreSQL/ActiveRecord database is a key feature of this web app. The process gives the product owner the ability to manage product actions through the Freshbooks website interface. The Skunkwerx webapp subscribes to any updates( [webhooks](http://en.wikipedia.org/wiki/Webhook) ) in Fresbooks products resulting in parity between the two databases.

## Installation

Run the following command to install it:

```console
git clone https://github.com/Lyonsclay/skunkwerx.git
```

Run the basic tests:

```console
rspec
```

```console
rake test
```

Run tests that make api call:

```console
API=run rspec
```

Run tests that implement webhooks with **[FreshBooks API](http://developers.freshbooks.com)**:

```console
WEBHOOKS=run rspec
```

Testing is everything and I continue to strive for [TDD](http://en.wikipedia.org/wiki/Test-driven_development), [BDD](http://en.wikipedia.org/wiki/Behavior-driven_development), and 100% test coverage. I utilized both Rspec and Test::Unit to get a feel for both processes. First of all, I was glad to find out that both frameworks can work in the same Rails app. I found Test::Unit easier to use and learn, but Rspec had additional features that allowed me to flag tests that were making live calls to websites, apis, and the Skunkwerx app itself.

I made the, perhaps unusual, decision to place certain methods that integrate with the client’s Freshbooks account through the Freshbooks API into the Rspec test suite. Rather than give certain admin users roles to define their access to methods it felt natural to place these actions out of the mvp venue and closer to the heart of maintenance, that being testing, where the developer alone has access to and utility of . This also allows me to run a few tests from a local environment in order to easily monitor the health of the overall app.

In the instance of a webhook request there is the call, the response, and then a verification routine. The call is being made from the local machine through an Rspec test. However, the response and verification routine are directed to the app's deployed domain name skunkwerx-performance.com. I discovered that the test of a response actually occurred before the verification routine completed and therefore gave a false result to tests that relied on the verification. I embedded a routine that effectively delayed the test of verification.

from spec/support/features/callback_helpers.rb
```ruby
num = 0
# This until loop provides small delay for app at
# skunkwerx-performance.com to receive verify callback,
# and authenticate verify callback with Freshbooks API.
until callback_verify == "1" || num == 10 do
  num += 1
  doc = Document.new callbacks_display.to_xml
  callbacks = REXML::XPath.match(doc, '//callback/event')
  callback = callbacks.keep_if { |c| c.text == method }
  callback_verify = callback.first.next_element.text
end
```

## Gems

For parsing external websites:

```ruby
gem "nokogiri"
gem "rexml"
gem "http"
gem "uri"
```

###For making api calls and reading responses:

The admin/freshbooks_helper method contains a full set of commands for interacting with the Freshbooks API including the implementation of webhooks. This particular file feels a bit heavy to be sitting in the core app's mvp logic. I would prefer that this was abstracted into a gem that had it's own maintenance and testing. It also would be nice to have a class designated for Freshbooks calls that followed a similar pattern to that of net/http.

[Freshbooks API](http://developers.freshbooks.com)

The following is the basic call method to the Freshbooks API which lives in app/helpers/admin/freshbooks_helper.rb.

```ruby
  def freshbooks_call(message)
    uri = URI.parse(ENV['FRESHBOOKS_URL'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth ENV['FRESHBOOKS_KEY'], 'X'
    request.body = message
    response = http.request(request)
  end
```

For parsing http response and web templates I chose to use  REXML, a pure Ruby XML processor, xpath, hash, and css methods. My intent was to experiment with different technologies and learn them. In conclusion I've found hash methods to be the easiest and xpath to be the most efficient for parsing. I am considering converting other techniques to xpath for efficiency and uniformity.

Of particular concern is the reliance on a css hiearchy that the scraper functionality in malone_tunes relies upon. If any changes to their page structure occur the functionality is useless. While I have planned on that inevitability I want to minimizes the losses by using attribute names that xpath can find recursively.

###For production on Heroku:

```ruby
gem "unicorn"
gem "rails_12factor"
gem "dalli"
```

###For image management:

```ruby
gem "paperclip"
gem "aws-dk"
```

###For testing:

```ruby
gem "rspec"
gem "capybara"
gem "factorygirl"
```

## Styles

Namespaceing assets and utilizing style method. Hand made css solutions.

Rails can be easily integrated to the [Bootstrap](http://getbootstrap.com/).
To do that you have to use the `bootstrap` option in the install generator, like this:

```console
rails generate simple_form:install --bootstrap
```

You have to be sure that you added a copy of the [Bootstrap](http://getbootstrap.com/)
assets on your application.

## Debugging

'pry'

I couldn't get the debugger gem to work with Rails 4.0.2 so I used pry.

```console
binding.pry
```

This statement open ups a terminal session at the point where the program encounters it.

## Conclusion

What remains to be implemented is the functionality of a shopping cart and integration with PayPal and perhaps another payment service down the line.

Then there is getting 100% test coverage.

## Resources

[Hartl Tutorial](http://www.railstutorial.org/book)

[Railscasts](http://railscasts.com/episodes/275-how-i-test)

[Pragmatic Programmers](http://pragprog.com/book/rails4/agile-web-development-with-rails-4)

[![Coverage Status](https://coveralls.io/repos/Lyonsclay/skunkwerx/badge.png)](https://coveralls.io/r/Lyonsclay/skunkwerx)

<tt>rake doc:app</tt>