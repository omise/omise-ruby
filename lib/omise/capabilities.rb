require "omise/object"

module Omise
  class Capabilities < OmiseObject
    self.endpoint = "/capability"
    singleton!

    def payment_backends
    	self.attributes['payment_backends'].map{ |backend| backend.values[0].merge({'id' => backend.keys[0]}) }
    end

    def self.resource_key
      Omise.public_api_key
    end

  end
end
