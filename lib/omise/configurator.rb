module Omise
  module Configurator
    # Gets the currently configured client. If none have been set, the first
    # call to this method will instantiate an empty client which will defaults
    # its configuration and credentials to this class. You can override this
    # by instantiating a new client with a new configuration and credentials 
    # and set it as the default client by calling `Omise.client = client`.
    #
    # Returns an {Client}.
    #
    def client
      Thread.current[:omise_client] ||= Client.new
    end

    # Sets a new client.
    #
    # Returns an {Client}.
    #
    def client=(client)
      Thread.current[:omise_client] = client
    end

    # Swap client for the duration of the given block. You can either pass an
    # instance of {Client} or a Hash containing two keys: `:secret_api_key` and
    # `:public_api_key`.
    #
    # Returns the result of the block.
    #
    def use_client(new_client)
      if new_client.is_a?(Hash)
        new_client = Client.with_credentials(new_client)
      end

      old_client, ::Omise.client = ::Omise.client, new_client
      yield
    ensure
      ::Omise.client = old_client
    end

    # Getter and setter for the base URL of the main API.
    #
    # This is the base URL of all objects except {Token}.
    #
    attr_accessor :api_url

    # Getter and setter for the base URL of the vault API.
    #
    # This is currently used only to interact with the {Token} API.
    #
    attr_accessor :vault_url

    # Getter and setter for the user agent suffix. This suffix will be added
    # at the end of the `User-Agent` header for every API request made to the
    # Omise API.
    #
    attr_accessor :user_agent_suffix

    # Backward compatibility with old API Keys naming conventions
    #
    # This key is used for all call to the main API.
    #
    attr_accessor :secret_api_key

    # Getter and setter to set your public API key. This key can be found in
    # your dashboard.
    #
    # This key is used for all calls to the vault API.
    #
    attr_accessor :public_api_key

    # Sets a logger to be used by the HTTP Logger.
    #
    # Returns a new {HTTPLogger} that wraps the given logger.
    #
    def logger=(logger)
      @http_logger = Omise::HTTPLogger.new(logger)
    end

    # Gets or initialize a void HTTP Logger.
    #
    # Returns an {HTTPLogger}.
    #
    def http_logger
      @http_logger ||= Omise::HTTPLogger.new
    end
  end
end
