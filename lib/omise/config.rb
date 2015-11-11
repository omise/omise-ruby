require "omise/http_logger"
require "omise/resource"

module Omise
  LIB_PATH = File.expand_path("../../", __FILE__)

  class << self
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

    # A getter and setter for the resource object. The resource is to be used
    # as a wrapper for an HTTP client.
    #
    # See `omise/resource.rb` to see which API is expected of a resource object.
    #
    attr_accessor :resource

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
    attr_writer :secret_api_key

    # A setter to set your public API key. This key can be found in
    # your dashboard.
    #
    # This key is used for all calls to the vault API.
    #
    attr_writer :public_api_key

    # Gets the secret API key.
    #
    # Returns the secret API key or raises a `RuntimeError`.
    #
    def secret_api_key
      get_key :secret_api_key
    end

    # Gets the public API key.
    #
    # Returns the secret API key or raises a `RuntimeError`.
    #
    def public_api_key
      get_key :public_api_key
    end

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
    # Returns an {HTTPLogger} or nil.
    #
    def http_logger
      @http_logger ||= Omise::HTTPLogger.new
    end

    # Switch over to a test mode so that no requests are made while running
    # the test suite.
    #
    # Returns nil.
    #
    def test!
      if !defined?(Omise::Testing::Resource)
        require "omise/testing/resource"
      end

      self.resource = Omise::Testing::Resource

      nil
    end

    private

    def get_key(name)
      if key = instance_variable_get("@#{name}")
        key
      else
        raise "Set Omise.#{name} to use this feature"
      end
    end
  end

  self.api_url   = "https://api.omise.co"
  self.vault_url = "https://vault.omise.co"
  self.resource  = Resource
end
