require "omise/object"

module Omise
  # {Balance} allows you to retrieve an Omise balance. Note that the `/balance`
  # endpoint is a singleton resource. But this class isn't a singleton and each
  # balance object that you fetch will have it's own object_id.
  #
  # Example:
  #
  #     Omise.api_key = OMISE_API_KEY
  #     balance = Omise::Balance.retrieve
  #
  # Alternatively if you have mutliple accounts you can retrieve each balance
  # separately by passing the `key:` option to retrieve all of them.
  #
  #     balances = keys.map do |key|
  #       begin
  #         Omise::Balance.retrieve(key: key)
  #       rescue Omise::Error => e
  #         # deal with exception accordingly
  #         nil
  #       end
  #     end.compact
  #
  class Balance < OmiseObject
    self.endpoint = "/balance"

    # Retrieves the current {Balance}.
    #
    # Returns a {Balance} instance if successful and raises an {Error} if the
    # request fails.
    #
    def self.retrieve(params = {})
      account.get(location, params: params)
    end

    # Reload the balance object. Calling this method will issue a single
    # HTTP request:
    #
    #   - GET https://api.omise.co/balance
    #
    # Example:
    #
    #     balance = Omise::Balance.retrieve
    #     balance.reload
    #
    # Returns the same {Balance} instance with updated attributes if successful
    # and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes account.get(location, params: params, as: Hash)
    end

    # Gets the location of the balance which will always be equal to the
    # {Balance.endpoint}.
    #
    # Returns a {String}.
    #
    def location
      self.class.location
    end
  end
end
