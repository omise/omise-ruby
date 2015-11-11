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

    include Resource

    def initialize(attributes = {}, options = {})
      @credentials = {
        secret_api_key: options.delete(:secret_api_key),
        public_api_key: options.delete(:public_api_key),
      }
      @configuration = {
        api_url: options.delete(:api_url),
        vault_url: options.delete(:vault_url),
        user_agent_suffix: options.delete(:user_agent_suffix),
        http_logger: options.delete(:http_logger),
      }

      super(attributes, options)
    end

    # Initializes a new {Account} with the given secret and public api keys.
    # Note that the attributes are not automatically fetched from the server and
    # you will have to call {Account#reload} in order to have access to all the
    # attributes of your account.
    #
    # Example:
    #
    #     account = Omise::Account.with_credentials(secret_api_key: key)
    #     account.reload
    #
    # Returns an instance of {Account}.
    #
    def self.with_credentials(secret_api_key:, public_api_key: nil)
      new({}, { secret_api_key: secret_api_key, public_api_key: public_api_key })
    end

    # Retrieves the current {Account}.
    #
    # Returns an {Account} instance if successful and raises an {Error} if the 
    # request fails.
    #
    def self.retrieve(params = {})
      account.get(location, params: params)
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
      assign_attributes account.get(location, params: params, as: Hash)
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

    private

    def get_configuration(name)
      @configuration[name] || Omise.send(name)
    end

    def get_credential(name)
      key = (@credentials["#{name}_api_key".to_sym] || Omise.send("#{name}_api_key"))

      unless key
        raise "Set Omise.#{name} to use this feature"
      end

      key
    end

    def http_logger
      @configuration[:http_logger]
    end

    def account
      self
    end
  end
end
