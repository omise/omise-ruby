require "omise/object"
require "omise/list"

module Omise
  class Receipt < OmiseObject
    self.endpoint = "/receipts"

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end
  end
end
