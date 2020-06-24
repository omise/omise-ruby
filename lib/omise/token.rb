module Omise
  class Token < OmiseObject
    self.endpoint = "/tokens"

    def self.retrieve(id, params = {})
      client.get(location(id), params: params, scope: :vault)
    end

    def self.create(params = {})
      client.post(location, params: params, scope: :vault)
    end

    def reload(params = {})
      assign_attributes client.get(location, params: params, as: Hash, scope: :vault)
    end
  end
end
