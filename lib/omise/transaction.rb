require "omise/resource"

module Omise
  class Transaction < Resource
    def self.endpoint
      "transactions"
    end
  end
end
