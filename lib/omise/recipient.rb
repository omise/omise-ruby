require "omise/object"
require "omise/bank_account"
require "omise/search_scope"

module Omise
  class Recipient < OmiseObject
    self.endpoint = "/recipients"

    AVAILABLE_SEARCH_FILTERS = %w[
      type
    ]

    def self.search
      SearchScope.new(:recipient, AVAILABLE_SEARCH_FILTERS)
    end

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
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

    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end

    def bank_account
      expand_attribute BankAccount, "bank_account"
    end
  end
end
