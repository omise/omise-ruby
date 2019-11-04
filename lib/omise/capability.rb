require "omise/object"

module Omise
  class Capability < OmiseObject
    self.endpoint = "/capability"
    singleton!

    def self.resource_key
      Omise.public_api_key
    end
  end
end
