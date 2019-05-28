require "omise/object"
require "omise/list"

module Omise
  class Chain < OmiseObject
    self.endpoint = "/chains"

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes), options
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def revoke(attributes = {})
      assign_attributes nested_resource("revoke", attributes).post(attributes)
    end
  end
end
