require "omise/account"
require "omise/balance"
require "omise/card"
require "omise/charge"
require "omise/customer"
require "omise/error"
require "omise/token"
require "omise/transaction"
require "omise/transfer"
require "omise/version"

module Omise
  CA_BUNDLE_PATH = File.expand_path("../../data/ca_certificates.pem", __FILE__)

  class << self
    attr_writer :api_key, :vault_key
    attr_accessor :api_url, :vault_url

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

  self.api_url = "https://api.omise.co/"
  self.vault_url = "https://vault.omise.co/"
end
