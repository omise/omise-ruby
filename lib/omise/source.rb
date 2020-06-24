module Omise
  class Source < OmiseObject
    self.endpoint = "/sources"

    def self.retrieve(id, params = {})
      client.get(location(id), params: params)
    end

    def self.create(params = {})
      client.post(location, params: params)
    end
  end
end
