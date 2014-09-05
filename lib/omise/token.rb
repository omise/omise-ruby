require "omise/thing"

module Omise
  class Token < Thing
    def self.endpoint
      "tokens"
    end
  end
end
