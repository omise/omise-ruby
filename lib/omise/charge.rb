require "omise/object"
require "omise/list"
require "omise/refund_list"
require "omise/search_scope"
require "omise/scheduler"

module Omise
  class Charge < OmiseObject
    self.endpoint = "/charges"

    def self.search
      SearchScope.new(:charge)
    end

    def self.schedule(attributes = {})
      Scheduler.new(:charge, attributes)
    end

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes), options
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
      if !defined?(Customer)
        require "omise/customer"
      end

      expand_attribute Customer, "customer", options
    end

    def dispute(options = {})
      if !defined?(Dispute)
        require "omise/dispute"
      end

      expand_attribute Dispute, "dispute", options
    end

    def transaction(options = {})
      if !defined?(Transaction)
        require "omise/transaction"
      end

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
