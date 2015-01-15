require "omise/object"
require "omise/list"

module Omise
  class Transaction < OmiseObject
    self.endpoint = "/transactions"

    def self.retrieve(id = nil, attributes = {})
      new resource(location(id), attributes).get
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get
    end
  end
end
