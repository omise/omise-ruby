require "omise/object"
require "omise/charge"
require "omise/list"

module Omise
  class Dispute < OmiseObject
    self.endpoint = "/disputes"

    def self.list(attributes = {})
      status = attributes.delete(:status)
      List.new resource(location(status), attributes).get(attributes)
    end

    def self.retrieve(id = nil, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    def charge(options = {})
      expand_attribute Charge, "charge", options
    end
  end
end
