require "omise/resource"

module Omise
  class Balance < Resource
    def self.endpoint
      "balance"
    end
  end
end
