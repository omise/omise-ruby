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

    # Make this class a singleton resource. See `omise/singleton_resource.rb`
    # for more information to see which methods are available.
    #
    singleton!
  end
end
