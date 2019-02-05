require "omise/object"

module Omise
  class Capabilities < OmiseObject
    self.endpoint = "/capability"
    singleton!

    def backends
    	self.payment_backends.map{ |backend| backend.values[0].merge({_id: backend.keys[0]}) }
    end

    def self.resource_key
      Omise.public_api_key
    end

  end
end
