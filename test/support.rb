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
