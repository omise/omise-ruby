require "omise/object"
require "omise/bank_account"

module Omise
  class Recipient < OmiseObject
    self.endpoint = "/recipients"

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

    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end

    def bank_account
      if @attributes["bank_account"]
        @bank_account ||= BankAccount.new(@attributes["bank_account"])
      end
    end

    private

    def cleanup!
      @bank_account = nil
    end
  end
end
