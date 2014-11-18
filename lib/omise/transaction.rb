require "omise/object"

module Omise
  class Transaction < OmiseObject
    self.endpoint = "transactions"

    def self.retrieve(id = nil, attributes = {})
      if id.nil?
        List.new resource(location, attributes).get
      else
        new resource(location(id), attributes).get
      end
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get
    end
  end
end
