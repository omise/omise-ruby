require "omise/object"

module Omise
  class Transfer < OmiseObject
    self.endpoint = "transfers"

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

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

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end
  end
end
