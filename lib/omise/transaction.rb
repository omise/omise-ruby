require "omise/object"
require "omise/list"

module Omise
  class Transaction < OmiseObject
    self.endpoint = "/transactions"

    def self.retrieve(id = nil, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes), options
    end
  end
end
