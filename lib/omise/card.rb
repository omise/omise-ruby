require "omise/thing"

module Omise
  class Card < Thing
    def self.endpoint
      "cards"
    end
  end
end
