require "rubygems"
require "bundler/setup"

Bundler.require(:default, :test)

require "minitest/autorun"

module Omise
  class Test < Minitest::Test
    def before_setup
      Omise.test!
      Omise.vault_key   = "pkey_test_4yq6tct0llin5nyyi5l"
      Omise.api_key     = "skey_test_4yq6tct0lblmed2yp5t"
      Omise.api_version = nil
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
  end
end
