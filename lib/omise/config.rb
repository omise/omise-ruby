require "omise/http_logger"
require "omise/resource"

module Omise
  LIB_PATH = File.expand_path("../../", __FILE__)

  class << self
    attr_accessor :api_url, :vault_url, :api_version, :resource, :user_agent_suffix

    attr_writer :secret_api_key, :public_api_key, :app_key

    def secret_api_key
      get_key :secret_api_key
    end

    def public_api_key
      get_key :public_api_key
    end

    def app_key
      get_key :app_key
    end

    # Backward compatibility with old API Keys naming conventions
    #
    # Will be removed in 1.0
    alias_method :api_key,    :secret_api_key
    alias_method :api_key=,   :secret_api_key=
    alias_method :vault_key,  :public_api_key
    alias_method :vault_key=, :public_api_key=

    def logger=(logger)
      @http_logger = Omise::HTTPLogger.new(logger)
    end

    def http_logger
      @http_logger ||= Omise::HTTPLogger.new
    end

    def test!
      if !defined?(Omise::Testing::Resource)
        require "omise/testing/resource"
      end

      self.resource = Omise::Testing::Resource
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
