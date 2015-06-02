require "omise/object"
require "omise/charge"
require "omise/transaction"

module Omise
  class Refund < OmiseObject
    self.endpoint = "/refunds"

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def charge(options = {})
      if @attributes["charge"]
        @charge ||= Charge.retrieve(@attributes["charge"], options)
      end
    end

    def transaction(options = {})
      if @attributes["transaction"]
        @transaction ||= Transaction.retrieve(@attributes["transaction"], options)
      end
    end

    private

    def cleanup!
      @charge = nil
      @transaction = nil
    end
  end
end
