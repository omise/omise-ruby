require "omise/object"
require "omise/list"

module Omise
  class Transaction < OmiseObject
    self.endpoint = "/transactions"

    def self.retrieve(id = nil, attributes = {})
      account.get(location(id), attributes)
    end

    def self.list(attributes = {})
      account.get(location, attributes)
    end
  end
end
