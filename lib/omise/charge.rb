require "omise/object"
require "omise/list"
require "omise/customer"
require "omise/dispute"
require "omise/refund_list"
require "omise/search_scope"
require "omise/transaction"

module Omise
  class Charge < OmiseObject
    self.endpoint = "/charges"

    AVAILABLE_SEARCH_FILTERS = %w[
      amount
      authorized
      capture
      captured
      card_last_digits
      created
      customer_present
      failure_code
      failure_message
      refund_amount
      refunded
      reversed
      status
    ]

    def self.search
      SearchScope.new(:charge, AVAILABLE_SEARCH_FILTERS)
    end

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
    end

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    def capture(options = {})
      assign_attributes nested_resource("capture", options).post
    end

    def reverse(options = {})
      assign_attributes nested_resource("reverse", options).post
    end

    def customer(options = {})
      expand_attribute Customer, "customer", options
    end

    def dispute(options = {})
      expand_attribute Dispute, "dispute", options
    end

    def transaction(options = {})
      expand_attribute Transaction, "transaction", options
    end

    def refunds
      list_attribute RefundList, "refunds"
    end

    def captured
      lookup_attribute_value :captured, :paid
    end

    def paid
      lookup_attribute_value :paid, :captured
    end
  end
end
