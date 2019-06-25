require "omise/object"

module Omise
  class Token < OmiseObject
    self.endpoint = "/tokens"

    def self.retrieve(id, params = {})
      account.get(location(id), params: params, scope: :vault)
    end

    def self.create(params = {})
      account.post(location, params: params, scope: :vault)
    end

    def reload(params = {})
      assign_attributes account.get(location, params: params, as: Hash, scope: :vault)
    end
  end
end
