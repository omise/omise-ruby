require "simplecov"
require "simplecov_json_formatter"
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start do
  add_filter "test/"
end

require "rubygems"
require "bundler/setup"

Bundler.require(:default, :test)

require "minitest/autorun"

module Omise
  class Test < Minitest::Test
    def before_setup
      Omise.test!
      Omise.api_version    = nil
      Omise.public_api_key = "pkey_test_4yq6tct0llin5nyyi5l"
      Omise.secret_api_key = "skey_test_4yq6tct0lblmed2yp5t"
      Omise.app_key = "app_test_4yq6tct0lblmed2yp5t"
    end

    def setup
      before_setup
    end

    def self.setup(&block)
      define_method :setup do
        before_setup
        instance_exec(&block)
      end
    end

    private

    def without_keys
      original_vault_key = Omise.vault_key
      original_api_key   = Omise.api_key

      Omise.vault_key = nil
      Omise.api_key   = nil

      yield

      Omise.vault_key = original_vault_key
      Omise.api_key   = original_api_key
    end
  end
end
