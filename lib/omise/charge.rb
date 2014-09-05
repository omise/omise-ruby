require "omise/thing"

module Omise
  class Charge < Thing
    def self.endpoint
      "charges"
    end
  end
end
