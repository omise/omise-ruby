require "omise/thing"

module Omise
  class Account < Thing
    def self.endpoint
      "account"
    end
  end
end
