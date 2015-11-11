require "omise/object"

module Omise
  # {Account} allows you to retrieve an Omise account. Note that the `/account`
  # endpoint is a singleton resource. But this class isn't a singleton and each
  # account object that you fetch will have it's own object_id.
  #
  # Example:
  #
  #     Omise.api_key = OMISE_API_KEY
  #     account = Omise::Account.retrieve
  #
  # Alternatively if you have mutliple accounts you can retrieve all of them
  # separately by passing the `key:` option:
  #
  #     accounts = keys.map do |key|
  #       begin
  #         Omise::Account.retrieve(key: key)
  #       rescue Omise::Error => e
  #         # deal with exception accordingly
  #         nil
  #       end
  #     end.compact
  #
  class Account < OmiseObject
    self.endpoint = "/account"

    # Make this class a singleton resource. See `omise/singleton_resource.rb`
    # for more information to see which methods are available.
    #
    singleton!
  end
end
