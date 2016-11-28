module Omise
  LIB_PATH = File.expand_path("../../", __FILE__)

  class << self
    attr_writer :api_key, :vault_key
    attr_accessor :api_url, :vault_url, :api_version, :resource

    def api_key
      get_key :api
    end

    def vault_key
      get_key :vault
    end

    def test!
      if !defined?(Omise::Testing::Resource)
        require "omise/testing/resource"
      end

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

  require "omise/resource"

  self.api_url   = "https://api.omise.co"
  self.vault_url = "https://vault.omise.co"
  self.resource  = Resource
end
