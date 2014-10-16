require "omise/object"

module Omise
  class Transfer < OmiseObject
    self.endpoint = "transfers"

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get
    end
  end
end
