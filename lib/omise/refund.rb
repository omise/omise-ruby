require "omise/object"
require "omise/search_scope"

module Omise
  class Refund < OmiseObject
    self.endpoint = "/refunds"

    def self.search
      SearchScope.new(:refund)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def charge(options = {})
      if !defined?(Charge)
        require "omise/charge"
      end

      expand_attribute Charge, "charge", options
    end

    def transaction(options = {})
      if !defined?(Transaction)
        require "omise/transaction"
      end

      expand_attribute Transaction, "transaction", options
    end
  end
end
