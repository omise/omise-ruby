require "omise/resource"

module Omise
  class Account < Resource
    def self.endpoint
      "account"
    end
  end
end
