require "omise/object"

module Omise
  class Account < OmiseObject
    self.endpoint = "/account"

    def self.retrieve(attributes = {})
      new resource(location, attributes).get(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end
  end
end
