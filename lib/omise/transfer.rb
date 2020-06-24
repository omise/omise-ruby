module Omise
  class Transfer < OmiseObject
    self.endpoint = "/transfers"

    def self.search
      SearchScope.new(:transfer)
    end

    def self.schedule(params = {})
      Scheduler.new(:transfer, params: params)
    end

    def self.create(params = {})
      client.post(location, params: params)
    end

    def self.retrieve(id, params = {})
      client.get(location(id), params: params)
    end

    def self.list(params = {})
      client.get(location, params: params)
    end

    def reload(params = {})
      assign_attributes client.get(location, params: params)
    end

    def update(params = {})
      assign_attributes client.patch(location, params: params)
    end

    def destroy
      assign_attributes client.delete(location)
    end

    def recipient(params = {})
      if !defined?(Recipient)
        require "omise/recipient"
      end

      expand_attribute Recipient, "recipient", params
    end

    def bank_account
      if !defined?(BankAccount)
        require "omise/bank_account"
      end

      expand_attribute BankAccount, "bank_account"
    end
  end
end
