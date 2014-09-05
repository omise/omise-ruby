require "omise/thing"

module Omise
  class Customer < Thing
    def self.endpoint
      "customers"
    end
  end
end
