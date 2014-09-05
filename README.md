# Omise Ruby Client

## Installation

Install using bundle (via github only at this time).

```ruby
gem ‘omise', github: ‘omise/omise-ruby’
```

## Examples

First configure your api key.

```ruby
Omise.api_key = "skey_test_4xa89ox4z4bcfrikkh2"
```

Then you're ready to go. Here's how to create, find, update and destroy a customer:

```
customer = Omise::Customer.create({
  description: "John Doe",
  email: "john.doe@example.com"
})

customer.attributes #  =>  {
  "object" => "customer",
  "id" => "...",
  "livemode" => false,
  "location" => "/customers/...",
  "default_card" => nil,
  "email" => "john.doe@example.com",
  "description" => "John Doe",
  "created" => "2014-09-05T09:03:05Z",
  "cards" =>  { object: "list", ... }
}

customer = Omise::Customer.find(customer.id)

customer.update description: "John W. Doe"
customer.description # => "John W. Doe"

customer.destroy
customer.destroyed? # => true
```
