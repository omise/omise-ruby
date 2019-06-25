require "omise/object"
require "omise/list"
require "omise/card_list"
require "omise/search_scope"

module Omise
  # A {Customer} represents a person who holds one or more cards. customer can
  # be passed to the {Charge.create} method instead of a token in order to
  # charge the customer's default card.
  #
  # See https://www.omise.co/customers-api for more information regarding
  # the customer attributes, the available endpoints and the different
  # parameters each endpoint accepts.
  #
  class Customer < OmiseObject
    self.endpoint = "/customers"

    # Initializes a search scope that when executed will search through your
    # account's customers.
    #
    # Example:
    #
    #     results = Omise::Customer.search
    #       .filter(created: "today")
    #       .execute
    #
    # Returns a {SearchScope} instance.
    #
    def self.search
      SearchScope.new(:customer)
    end

    # Retrieves a customer object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/customers/CUSTOMER_ID
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #
    # Returns a new {Customer} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.retrieve(id, params = {})
      account.get(location(id), params: params)
    end

    # Retrieves a list of customer objects.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/customers
    #
    # By default the list will be returned in chronological order. You can
    # inverse the order to start from the latest customers in your account by
    # passing `reverse_chronological` to the `order:` option. You can also
    # restrict what customers will be returned by passing the `from:` and/or
    # `to:` options. Lastly you can paginate the results by using the `offset:`
    # and `limit:` options. You can find out more about pagination and list
    # options by visiting https://www.omise.co/api-pagination.
    #
    # Examples:
    #
    #     # First customers
    #     customers = Omise::Customer.list
    #
    #     # Latest customers
    #     customers = Omise::Customer.list(order: "reverse_chronological")
    #
    # Returns a new {List} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.list(params = {})
      account.get(location, params: params)
    end

    # Creates a new customer.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/customers
    #
    # Example:
    #
    #     customer = Omise::Customer.create({
    #       email: "john@example.com",
    #       card: token_id
    #     })
    #
    # Returns a new {Customer} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.create(params = {})
      account.post(location, params: params)
    end

    # Reloads an existing customer.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/customers/CUSTOMER_ID
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     customer.reload
    #
    # Returns the same {Customer} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes account.get(location, params: params, as: Hash)
    end

    # Updates an existing customer.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - PATCH https://api.omise.co/customers/CUSTOMER_ID
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     customer.update(description: "John Doe")
    #
    # Returns the same {Customer} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def update(params = {})
      assign_attributes account.patch(location, params: params, as: Hash)
    end

    # Destroys an existing customer.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - DELETE https://api.omise.co/customers/CUSTOMER_ID
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     customer.destroy
    #     customer.destroyed? # => true
    #
    # Returns the same {Customer} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def destroy
      assign_attributes account.delete(location, as: Hash)
    end

    # List schedules attached to this customer.
    #
    # Calling this method will issue a single HTTP request.
    #
    #   - GET https://api.omise.co/customers/CUSTOMER_ID/schedules
    #
    # Examples:
    #
    #     # List all schedules
    #     customer  = Omise::Customer.retrieve(customer_id)
    #     schedules = customer.schedules
    #
    # Returns a new {List} instance or raises an {Error} if the request fails.
    #
    def schedules(params = {})
      account.get(location("schedules"), params: params)
    end

    # Charges the customer.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/charges
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     charge   = customer.charge(amount: 1000_00, currency: "THB")
    #     charge.paid # => true
    #
    # Returns a new {Charge} instance if successful or raises an {Error} if the
    # request fails.
    #
    def charge(params = {})
      if !defined?(Charge)
        require "omise/charge"
      end

      account.post(Charge.location, params: params.merge(customer: id))
    end

    # Typecasts or expands the default card attached to a customer if
    # it's present.
    #
    # Calling this method may issue a single HTTP request if the customer was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/customers/CUSTOMER_ID/cards/CARD_ID
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     card     = customer.default_card
    #
    # Returns a new {Card} instance if successful, nil if there's no card or
    # raises an {Error} if the request fails.
    #
    def default_card(params = {})
      expand_attribute cards, "default_card", params
    end

    # List cards attached to this customer.
    #
    # Calling this method may issue a single HTTP request if any options
    # are passed:
    #
    #   - GET https://api.omise.co/customers/CUSTOMER_ID/cards
    #
    # Examples:
    #
    #     # Simply list all cards without doing any network requests
    #     customer = Omise::Customer.retrieve(customer_id)
    #     cards    = customer.cards
    #
    #     # Make a network request because some options are present
    #     customer = Omise::Customer.retrieve(customer_id)
    #     cards    = customer.cards(expand: true)
    #
    # Returns a new {CardList} instance or raises an {Error} if the
    # request fails.
    #
    def cards(params = {})
      list_nested_resource CardList, "cards", params
    end
  end
end
