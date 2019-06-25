require "omise/object"

module Omise
  class Source < OmiseObject
    self.endpoint = "/sources"

    def self.retrieve(id, params = {})
      account.get(location(id), params: params)
    end

    def self.create(params = {})
      account.post(location, params: params)
    end
  end
end
