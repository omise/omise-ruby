require "omise/resource"

module Omise
  class Token < Resource
    def self.endpoint
      "tokens"
    end
  end
end
