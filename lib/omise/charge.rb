require "omise/object"
require "omise/customer"
require "omise/transaction"

module Omise
  class Charge < OmiseObject
    self.endpoint = "/charges"

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get
    end

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get
    end

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    def customer(options = {})
      if @attributes["customer"]
        @customer ||= Customer.retrieve(@attributes["customer"], options)
      end
    end

    def transaction(options = {})
      if @attributes["customer"]
        @transaction ||= Transaction.retrieve(@attributes["transaction"], options)
      end
    end

    private

    def cleanup!
      @customer = nil
      @transaction = nil
    end
  end
end
