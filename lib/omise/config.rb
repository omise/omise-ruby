require "omise/http_logger"

module Omise
  module Config
    def account
      Thread.current[:omise_account] ||= Account.new
    end

    def account=(account)
      Thread.current[:omise_account] = account
    end

    def use_account(new_account)
      if new_account.is_a?(Hash)
        new_account = Account.with_credentials(new_account)
      end

      old_account, ::Omise.account = ::Omise.account, new_account
      yield
    ensure
      ::Omise.account = old_account
    end

    # A getter and setter for the base URL of the main API. This will be used
    # for all {OmiseObject} that defines their `endpoint` and don't use the
    # {Vault} module.
    #
    # This is the base URL of all objects except {Token}.
    #
    attr_accessor :api_url

    # A getter and setter for the base URL of the vault API. This will be used
    # for all {OmiseObject} that defines their `endpoint` and use the
    # {Vault} module.
    #
    # This is currently used only to interact with the {Token} API.
    #
    attr_accessor :vault_url

    # A getter and setter for the user agent suffix. This suffix will be added
    # at the end of the `User-Agent` header for every API request made to the
    # Omise API.
    #
    attr_accessor :user_agent_suffix

    # A setter to set your secret API key. This key can be found in
    # your dashboard.
    #
    # This key is used for all call to the main API.
    #
    attr_accessor :secret_api_key

    # A setter to set your public API key. This key can be found in
    # your dashboard.
    #
    # This key is used for all calls to the vault API.
    #
    attr_accessor :public_api_key

    # @deprecated Backward compatibility for the old API Keys naming
    #   conventions. This will be removed in 1.0.
    #
    alias_method :api_key, :secret_api_key

    # @deprecated Backward compatibility for the old API Keys naming
    #   conventions. This will be removed in 1.0.
    #
    alias_method :api_key=, :secret_api_key=

    # @deprecated Backward compatibility for the old API Keys naming
    #   conventions. This will be removed in 1.0.
    #
    alias_method :vault_key, :public_api_key

    # @deprecated Backward compatibility for the old API Keys naming
    #   conventions. This will be removed in 1.0.
    #
    alias_method :vault_key=, :public_api_key=

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
