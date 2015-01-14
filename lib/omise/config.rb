require "omise/resource"

module Omise
  module Config
    attr_writer :api_key, :vault_key
    attr_accessor :api_url, :vault_url, :api_version, :resource

    def api_key
      get_key :api
    end

    def vault_key
      get_key :vault
    end

    def typecast(object)
      klass = begin
        const_get(object["object"].capitalize)
      rescue NameError
        OmiseObject
      end

      klass.new(object)
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

  extend Config

  self.api_url = "https://api.omise.co"
  self.vault_url = "https://vault.omise.co"
  self.api_version = "2014-07-27"
  self.resource = Resource
end
