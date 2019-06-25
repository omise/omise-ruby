require "omise/object"
require "omise/list"

module Omise
  class Chain < OmiseObject
    self.endpoint = "/chains"

    # Retrieves a chain object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/chains/CHAIN_ID
    #
    # Example:
    #
    #     chain = Omise::Chain.retrieve(chain_id)
    #
    # Returns a new {Chain} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.retrieve(id, params = {})
      account.get(location(id), params: params)
    end

    # Retrieves a list of chains objects.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/chains
    #
    # By default the list will be returned in chronological order. You can
    # inverse the order to start from the latest chains in your account by
    # passing `reverse_chronological` to the `order:` option. You can also
    # restrict what chains will be returned by passing the `from:` and/or
    # `to:` options. Lastly you can paginate the result by using the `offset:`
    # and `limit:` options. You can find out more about pagination and list
    # options by visiting https://www.omise.co/api-pagination.
    #
    # Examples:
    #
    #     # First chains
    #     chains = Omise::Chain.list
    #
    #     # Latest chains
    #     chain = Omise::Chain.list(order: "reverse_chronological")
    #
    # Returns a new {List} instance if successful and raises an {Error} if the
    # request fails.
    #
    def self.list(params = {})
      account.get(location, params: params)
    end

    # Reloads an existing chain.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/chains/CHAIN_ID
    #
    # Example:
    #
    #     chain = Omise::Chain.retrieve(chain_id)
    #     chain.reload
    #
    # Returns the same {Chain} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes account.get(location, params: params)
    end

    # Revokes an existing chain.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/chains/CHAIN_ID/revoke
    #
    # Example:
    #
    #     chain = Omise::Chain.retrieve(chain_id)
    #     chain.revoke
    #
    # Returns the same {Chain} instance with the `revoked` attribute set to true
    # if successful and raises an {Error} if the request fails.
    #
    def revoke(params = {})
      assign_attributes account.post(location("revoke"), params: params)
    end
  end
end
