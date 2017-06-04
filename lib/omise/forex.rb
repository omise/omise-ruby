require "omise/object"

module Omise
  class Forex < OmiseObject
    self.endpoint = "/forex"

    def self.from(currency, attributes = {})
      new resource(location(currency.to_s.downcase), attributes).get(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end
  end
end
