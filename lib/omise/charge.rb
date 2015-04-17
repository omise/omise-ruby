require "omise/object"
require "omise/list"
require "omise/customer"
require "omise/dispute"
require "omise/refund_list"
require "omise/transaction"

module Omise
  class Charge < OmiseObject
    self.endpoint = "/charges"

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get
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

    def dispute(options = {})
      if @attributes["dispute"]
        @dispute ||= Dispute.retrieve(@attributes["dispute"], options)
      end
    end

    def transaction(options = {})
      if @attributes["transaction"]
        @transaction ||= Transaction.retrieve(@attributes["transaction"], options)
      end
    end

    def refunds
      @refunds ||= RefundList.new(self, @attributes["refunds"])
    end

    private

    def cleanup!
      @customer = nil
      @dispute = nil
      @refunds = nil
      @transaction = nil
    end
  end
end
