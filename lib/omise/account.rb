require "uri"
require "openssl"
require "rest-client"

require "omise/object"
require "omise/util"
require "omise/version"

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
  # separately by using {Account.with_credentials} then calling reload. Note
  # that {with_credentials} won't automatically fetch the attributes for you.
  #
  #     accounts = keys.map do |key|
  #       begin
  #         Omise::Account.with_credentials(secret_api_key: key).reload
  #       rescue Omise::Error => e
  #         # deal with exception accordingly
  #         nil
  #       end
  #     end.compact
  #
  class Account < OmiseObject
    self.endpoint = "/account"

    # Retrieves the current {Account}.
    #
    # Returns an {Account} instance if successful and raises an {Error} if the
    # request fails.
    #
    def self.retrieve(params = {})
      client.get(location, params: params)
    end

    # Reload the account object. Calling this method will issue a single
    # HTTP request:
    #
    #   - GET https://api.omise.co/account
    #
    # Example:
    #
    #     account = Omise::Account.retrieve
    #     account.reload
    #
    # Returns the same {Account} instance with updated attributes if successful 
    # and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes client.get(location, params: params, as: Hash)
    end

    # Gets the parent of the account. Which is always nil.
    #
    # Returns nil.
    #
    def parent
      nil
    end

    # Gets the location of the account which will always be equal to the
    # {Account.endpoint}.
    #
    # Returns a {String}.
    #
    def location
      self.class.location
    end

    def account
      self
    end
  end
end
