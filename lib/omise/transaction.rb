require "omise/object"

module Omise
  class Transaction < OmiseObject
    self.endpoint = "transactions"

    def self.all(attributes = {})
      List.new resource(location, attributes).get
    end

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get
    end
  end
end
