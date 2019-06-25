require "omise/object"
require "omise/list"
require "omise/refund_list"
require "omise/search_scope"
require "omise/scheduler"

module Omise
  # A {Charge} represents a payment that has been made through one of the
  # payment methods available in the country where you're using Omise.
  #
  # See https://www.omise.co/charges-api for more information regarding
  # the charge attributes, the available endpoints and the different parameters
  # each endpoint accepts.
  #
  class Charge < OmiseObject
    self.endpoint = "/charges"

    # Initializes a search scope that when executed will search through your
    # account's charges.
    #
    # Example:
    #
    #     results = Omise::Charge.search
    #       .filter(authorized: true)
    #       .execute
    #
    # Returns a {SearchScope} instance.
    #
    def self.search
      SearchScope.new(:charge)
    end

    # Initializes a scheduler that when started will create a charge schedule.
    #
    # Example:
    #
    #     scheduler = Omise::Charge.schedule({
    #       customer: customer.omise_id,
    #       amount:   100000,
    #       currency: "thb",
    #     })
    #
    # Returns a {Scheduler} instance.
    #
    def self.schedule(params = {})
      Scheduler.new(:charge, params: params)
    end

    # Retrieves a charge object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/charges/CHARGE_ID
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #
    # Returns a new {Charge} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.retrieve(id, params = {})
      account.get(location(id), params: params)
    end

    # Retrieves a list of charge objects.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/charges
    #
    # By default the list will be returned in chronological order. You can
    # inverse the order to start from the latest charges in your account by
    # passing `reverse_chronological` to the `order:` option. You can also
    # restrict what charges will be returned by passing the `from:` and/or
    # `to:` options. Lastly you can paginate the result by using the `offset:`
    # and `limit:` options. You can find out more about pagination and list
    # options by visiting https://www.omise.co/api-pagination.
    #
    # Examples:
    #
    #     # First charges
    #     charges = Omise::Charge.list
    #
    #     # Latest charges
    #     charges = Omise::Charge.list(order: "reverse_chronological")
    #
    # Returns a new {List} instance if successful and raises an {Error} if the
    # request fails.
    #
    def self.list(params = {})
      account.get(location, params: params)
    end

    # Creates a new charge.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/charges
    #
    # Example:
    #
    #     # Create a charge with a customer
    #     charge = Omise::Charge.create({
    #       amount:   1000_00,
    #       currency: "THB",
    #       customer: customer_id,
    #     })
    #
    # Returns a new {Charge} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.create(params = {})
      account.post(location, params: params)
    end

    # Reloads an existing charge.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/charges/CHARGE_ID
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     charge.reload
    #
    # Returns the same {Charge} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes account.get(location, params: params, as: Hash)
    end

    # Updates an existing charge.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - PATCH https://api.omise.co/charges/CHARGE_ID
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     charge.update(description: "A better description for this charge")
    #
    # Returns the same {Charge} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def update(params = {})
      assign_attributes account.patch(location, params: params, as: Hash)
    end

    # Captures a charge that is in authorized state *only*.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/charges/CHARGE_ID/capture
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     charge.capture
    #
    # Returns the same {Charge} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def capture
      assign_attributes account.post(location("capture"), as: Hash)
    end

    # Reverses a charge that is in authorized state *only*.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/charges/CHARGE_ID/reverse
    #
    # Examples:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     charge.reverse
    #
    # Returns the same {Charge} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reverse
      assign_attributes account.post(location("reverse"), as: Hash)
    end

    # Typecasts or expands the customer attached to a charge if it's present.
    #
    # Calling this method may issue a single HTTP request if the charge was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/customers/CUSTOMER_ID
    #
    # Example:
    #
    #     charge   = Omise::Charge.retrieve(charge_id)
    #     customer = charge.customer
    #
    # Returns a new {Customer} instance if successful, nil if there's no
    # customer or raises an {Error} if the request fails.
    #
    def customer(params = {})
      if !defined?(Customer)
        require "omise/customer"
      end

      expand_attribute Customer, "customer", params
    end

    # Typecasts or expands the dispute attached to a charge if it's present.
    #
    # Calling this method may issue a single HTTP request if the charge was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/disputes/DISPUTE_ID
    #
    # Example:
    #
    #     charge  = Omise::Charge.retrieve(charge_id)
    #     dispute = charge.dispute
    #
    # Returns a new {Dispute} instance if successful, nil if there's no dispute 
    # or raises an {Error} if the request fails.
    #
    def dispute(params = {})
      if !defined?(Dispute)
        require "omise/dispute"
      end

      expand_attribute Dispute, "dispute", params
    end

    # Typecasts or expands the transaction attached to a charge if it's present.
    #
    # Calling this method may issue a single HTTP request if the charge was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/transactions/TRANSACTION_ID
    #
    # Example:
    #
    #     charge      = Omise::Charge.retrieve(charge_id)
    #     transaction = charge.transaction
    #
    # Returns a new {Transaction} instance if successful, nil if there's no
    # transaction or raises an {Error} if the request fails.
    #
    def transaction(params = {})
      if !defined?(Transaction)
        require "omise/transaction"
      end

      expand_attribute Transaction, "transaction", params
    end

    # List refunds attached to this charge.
    #
    # Calling this method may issue a single HTTP request if any options
    # are passed:
    #
    #   - GET https://api.omise.co/charges/CHARGE_ID/refunds
    #
    # Examples:
    #
    #     # Simply list all refunds without doing any network requests
    #     charge  = Omise::Charge.retrieve(charge_id)
    #     refunds = charge.refunds
    #
    #     # Make a network request because some options are present
    #     charge  = Omise::Charge.retrieve(charge_id)
    #     refunds = charge.refunds(expand: true)
    #
    # Returns a new {RefundList} instance or raises an {Error} if the
    # request fails.
    #
    def refunds(params = {})
      list_nested_resource RefundList, "refunds", params
    end

    # Tells wether or not the charge was paid. This method will return the
    # value of the `paid` attribute.
    #
    # Returns a boolean.
    #
    # @deprecated The `captured` attribute was originally present in the
    #   2014-07-27 version of the API and was later replaced in favor of
    #   the `paid` attribute.
    #
    def captured
      paid
    end
  end
end
