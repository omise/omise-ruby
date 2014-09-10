require "omise/resource"

module Omise
  class Card < Resource
    def self.endpoint
      "cards"
    end
  end
end
