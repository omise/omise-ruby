require "omise/object"
require "omise/bank_account"
require "omise/search_scope"

module Omise
  class Transfer < OmiseObject
    self.endpoint = "/transfers"

    def self.search
      SearchScope.new(:transfer)
    end

    def self.schedule(attributes = {})
      Scheduler.new(:transfer, attributes)
    end

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes), options
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

    def recipient(options = {})
      if !defined?(Recipient)
        require "omise/recipient"
      end

      expand_attribute Recipient, "recipient", options
    end

    def bank_account
      if !defined?(BankAccount)
        require "omise/bank_account"
      end

      expand_attribute BankAccount, "bank_account"
    end
  end
end
