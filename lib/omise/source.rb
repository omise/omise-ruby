require "omise/object"

module Omise
  class Source < OmiseObject
    self.endpoint = "/sources"

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end
  end
end
