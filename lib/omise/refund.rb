require "omise/object"
require "omise/search_scope"

module Omise
  # A {Refund} represents the return of a payment that has originally been made
  # through one of the payment methods available in the country where you're
  # using Omise. Note that not all payment methods supports refunds.
  #
  # See https://www.omise.co/refunds-api for more information regarding
  # the refund attributes, the available endpoints and the different parameters
  # each endpoint accepts.
  #
  class Refund < OmiseObject
    self.endpoint = "/refunds"

    # Initializes a search scope that when executed will search through your
    # account's refunds.
    #
    # Example:
    #
    #     results = Omise::Refund.search
    #       .filter(card_last_digits: "4242")
    #       .execute
    #
    # Returns a {SearchScope} instance.
    #
    def self.search
      SearchScope.new(:refund)
    end

    # Retrieves a list of refunds objects.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/refunds
    #
    # By default the list will be returned in chronological order. You can
    # inverse the order to start from the latest refunds in your account by
    # passing `reverse_chronological` to the `order:` option. You can also
    # restrict what refunds will be returned by passing the `from:` and/or
    # `to:` options. Lastly you can paginate the result by using the `offset:`
    # and `limit:` options. You can find out more about pagination and list
    # options by visiting https://www.omise.co/api-pagination.
    #
    # Examples:
    #
    #     # First refunds
    #     refunds = Omise::Refund.list
    #
    #     # Latest charges
    #     refunds = Omise::Refund.list(order: "reverse_chronological")
    #
    # Returns a new {List} instance if successful and raises an {Error} if the
    # request fails.
    #
    def self.list(params = {})
      client.get(location, params: params)
    end

    # Reloads an existing refund.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/charges/CHARGE_ID/refunds/REFUND_ID
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     refund = charge.refunds.retrieve(refund_id)
    #     refund.reload
    #
    # Returns the same {Refund} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes client.get(location, params: params, as: Hash)
    end

    # Typecasts or expands the charge attached to a refund.
    #
    # Calling this method may issue a single HTTP request if the refund was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/charges/CHARGE_ID
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     refund = charge.refunds.retrieve(refund_id)
    #     charge = refund.charge
    #
    # Returns a new {Charge} instance if successful or raises an {Error} if the
    # request fails.
    #
    def charge(params = {})
      if !defined?(Charge)
        require "omise/charge"
      end

      expand_attribute Charge, "charge", params
    end

    # Typecasts or expands the transaction attached to a refund.
    #
    # Calling this method may issue a single HTTP request if the refund was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/transactions/TRANSACTION_ID
    #
    # Example:
    #
    #     charge       = Omise::Charge.retrieve(charge_id)
    #     refund       = charge.refunds.retrieve(refund_id)
    #     transactions = refund.transactions
    #
    # Returns a new {Transaction} instance if successful or raises an {Error}
    # if the request fails.
    #
    def transaction(params = {})
      if !defined?(Transaction)
        require "omise/transaction"
      end

      expand_attribute Transaction, "transaction", params
    end
  end
end
