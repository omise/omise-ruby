# Omise Ruby Client

[![CodeClimate](https://img.shields.io/codeclimate/github/omise/omise-ruby.svg?style=flat)](https://codeclimate.com/github/omise/omise-ruby)
![CircleCI](https://img.shields.io/circleci/project/omise/omise-ruby.svg?style=flat)
[![Gem](https://img.shields.io/gem/v/omise.svg?style=flat)](https://rubygems.org/gems/omise)

## Installation

Installing via rubgems:

```ruby
gem 'omise'
```

Or use the cutting-edge version by installing via github:

```ruby
gem 'omise', github: 'omise/omise-ruby'
```

## Requirements

Requires ruby 1.9.2 or above, the rest-client and json gem.

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

if charge.captured
  # handle success
  puts "thanks"
else
  # handle failure
  raise charge.failure_code
end
```

You can check the complete documentation at
[docs.omise.co]](https://docs.omise.co/).

# Development

The test suite can be run with `bundle exec rake test`.
