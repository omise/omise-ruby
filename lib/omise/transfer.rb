require "omise/object"
require "omise/bank_account"
require "omise/list"
require "omise/recipient"

module Omise
  class Transfer < OmiseObject
    self.endpoint = "/transfers"

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end

    def recipient
      if @attributes["recipient"]
        @recipient ||= Recipient.retrieve(@attributes["recipient"])
      end
    end

    def bank_account
      if @attributes["bank_account"]
        @bank_account ||= BankAccount.new(@attributes["bank_account"])
      end
    end

    private

    def cleanup!
      @bank_account = nil
      @recipient = nil
    end
  end
end
