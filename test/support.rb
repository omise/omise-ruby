require "rubygems"
require "bundler/setup"

Bundler.require(:default, :test)

Omise.test!

# Dummy Keys
Omise.api_key = "pkey_test_4yq6tct0llin5nyyi5l"
Omise.vault_key = "skey_test_4yq6tct0lblmed2yp5t"

require "minitest/autorun"
