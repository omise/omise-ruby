require "omise/object"
require "omise/charge"
require "omise/transaction"

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
      expand_attribute Charge, "charge", options
    end

    def transaction(options = {})
      expand_attribute Transaction, "transaction", options
    end
  end
end
