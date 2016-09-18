# Omise Ruby Client

[![CodeClimate](https://img.shields.io/codeclimate/github/omise/omise-ruby.svg?style=flat)](https://codeclimate.com/github/omise/omise-ruby)
![CircleCI](https://img.shields.io/circleci/project/omise/omise-ruby.svg?style=flat)
[![Gem](https://img.shields.io/gem/v/omise.svg?style=flat)](https://rubygems.org/gems/omise)
[![Join the chat at https://gitter.im/omise/omise-ruby](https://badges.gitter.im/omise/omise-ruby.svg)](https://gitter.im/omise/omise-ruby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Installation

Installing via rubygems:

```ruby
gem 'omise'
```

Or use the cutting-edge version by installing via github:

```ruby
gem 'omise', github: 'omise/omise-ruby'
```

## Requirements

Requires ruby 1.9.2 or above, the rest-client and json gems.

## Configuration

First configure your secret key:

```ruby
Omise.api_key = "skey_test_xxxxxxxxxxxxxxxxxxx"
```

If you need to use the Token API you also need to set your public key:

```ruby
Omise.vault_key = "pkey_test_xxxxxxxxxxxxxxxxxxx"
```

With this set you'll be able to retrieve tokens or create new ones.

However we recommend using [Omise.js](https://gitub.com/omise/omise.js) to
create tokens. When creating a token server side you'll need card data
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
Omise.api_version = "2014-07-27"
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

After you have implemented [Omise.js](https://gitub.com/omise/omise.js) on your
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
[docs.omise.co](https://docs.omise.co/).

## Development

The test suite can be run with `bundle exec rake test`.
