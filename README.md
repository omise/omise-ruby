# Omise Ruby Client

[![Code Climate](https://codeclimate.com/github/omise/omise-ruby/badges/gpa.svg)](https://codeclimate.com/github/omise/omise-ruby)

## Installation

Install using bundle (via github only at this time).

```ruby
gem 'omise', github: 'omise/omise-ruby'
```

## Examples

First configure your api key.

```ruby
Omise.api_key = "skey_test_4xa89ox4z4bcfrikkh2"
```

Then you're ready to go. Here's how to create customer:

```ruby
customer = Omise::Customer.create({
  description: "John Doe",
  email: "john.doe@example.com"
})

puts customer.attributes
# {
#   "object" => "customer",
#   "id" => "...",
#   "livemode" => false,
#   "location" => "/customers/...",
#   "default_card" => nil,
#   "email" => "john.doe@example.com",
#   "description" => "John Doe",
#   "created" => "2014-09-05T09:03:05Z",
#   "cards" =>  {
#     "object": "list",
#     ...
#   }
# }
```

Then find, update and destroy that customer.

```ruby
customer = Omise::Customer.find("cust_test_4xald9y2ttb5mvplw0c")

customer.update description: "John W. Doe"
customer.description # => "John W. Doe"

customer.destroy
customer.destroyed? # => true
```
