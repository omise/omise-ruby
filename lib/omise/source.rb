require "omise/object"

module Omise
  class Source < OmiseObject
    self.endpoint = "/sources"

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end
  end
end
