# Omise Ruby Client

[![Maintainability](https://api.codeclimate.com/v1/badges/8297834e28572da75cf2/maintainability)](https://codeclimate.com/github/omise/omise-ruby/maintainability)
<img alt="GitHub Actions status" src="https://github.com/omise/omise-ruby/workflows/Ruby/badge.svg">
[![Gem](https://img.shields.io/gem/v/omise.svg?style=flat)](https://rubygems.org/gems/omise)

## Installation

Add the following to your `Gemfile` to install via RubyGems:

```ruby
gem 'omise'
```

Or use the cutting-edge version by installing via GitHub:

```ruby
gem 'omise', github: 'omise/omise-ruby'
```

## Requirements

Tested on Ruby 2.5 and above

## Configuration

First configure your secret key:

```ruby
require "omise"

Omise.api_key = "skey_test_xxxxxxxxxxxxxxxxxxx"
```



With this set you'll be able to retrieve tokens or create new ones.

However we recommend using [Omise.js](https://www.omise.co/omise-js-api) to
[collect cards](https://www.omise.co/collecting-card-information). When creating a token server side you'll need card data
transiting to and from your server and this requires that your organization be
PCI compliant.

### API version

In case you want to enforce API version the application use, you can specify it
by setting the `api_version`. The version specified by this settings will override
the version setting in your account. This is useful if you have multiple
environments with different API versions (e.g. development on the latest but
production on the older version).

```ruby
require "omise"
Omise.api_version = "2019-05-29"
```

It is highly recommended to set this version to the current version
you're using.

### Logging

To enable log you can set `Omise.logger` with a Ruby logger. All HTTP requests and responses will be logged.

To disable log, just configure `Omise.logger` to `nil`. Default is disabled.

An example configuring Rails logger:

```ruby
Omise.logger = Rails.logger
```

## Quick Start

After you have implemented [Omise.js](https://www.omise.co/omise-js-api) on your
frontend you can charge the card by passing the token into the `card` attribute.

```ruby
# Charge 1000.00 THB
charge = Omise::Charge.create({
  amount: 1_000_00,
  currency: "thb",
  card: params[:omise_token]
})

if charge.paid
  # handle success
  puts "thanks"
else
  # handle failure
  raise charge.failure_code
end
```

You can check the complete documentation at
[omise.co/docs](https://omise.co/docs).

## Development

The test suite can be run with `bundle exec rake test`.
