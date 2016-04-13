require "omise/logger"
require "omise/resource"

module Omise
  class << self
    attr_writer :api_key, :vault_key
    attr_accessor :api_url, :vault_url, :api_version, :resource
    attr_reader :logger

    def api_key
      get_key :api
    end

    def vault_key
      get_key :vault
    end

    def logger=(log)
      @http_logger = Omise::Logger.new(log)
      @logger = log
    end

    def http_logger
      @http_logger ||= Omise::Logger.new
    end

    def test!
      require "omise/testing/resource"
      self.resource = Omise::Testing::Resource
    end

    private

    def get_key(name)
      if key = instance_variable_get("@#{name}_key")
        key
      else
        raise "Set Omise.#{name}_key to use this feature"
      end
    end
  end

  self.api_url = "https://api.omise.co"
  self.vault_url = "https://vault.omise.co"
  self.resource = Resource
end
