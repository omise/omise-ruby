require "omise/http_logger"

module Omise
  module Config
    # Gets the currently configured account. If none have been set, the first
    # call to this method will instantiate an empty account which will defaults
    # its configuration and credentials to this class. You can override this
    # by instantiating a new account with a new configuration and credentials 
    # and set it as the default account by calling `Omise.account = account`.
    #
    # Returns an {Account}.
    #
    def account
      Thread.current[:omise_account] ||= Account.new
    end

    # Sets a new account.
    #
    # Returns an {Account}.
    #
    def account=(account)
      Thread.current[:omise_account] = account
    end

    # Swap account for the duration of the given block. You can either pass an
    # instance of {Account} or a Hash containing two keys: `:secret_api_key` and
    # `:public_api_key`.
    #
    # Returns the result of the block.
    #
    def use_account(new_account)
      if new_account.is_a?(Hash)
        new_account = Account.with_credentials(new_account)
      end

      old_account, ::Omise.account = ::Omise.account, new_account
      yield
    ensure
      ::Omise.account = old_account
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

    attr_accessor :app_key

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
