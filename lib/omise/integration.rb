require "omise/object"

module Omise
  class Integration < OmiseObject
    self.endpoint = "/integrations"

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.resource_key
      Omise.app_key
    end

  end
end
