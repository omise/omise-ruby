require "omise/resource"

module Omise
  class Customer < Resource
    def self.endpoint
      "customers"
    end
  end
end
