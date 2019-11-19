require "omise/object"

module Omise
  class Integration < OmiseObject
    self.endpoint = "/integrations"

    def self.retrieve(id, params = {})
      account.get(location(id), params: params)
    end
  end
end
