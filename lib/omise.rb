require "rest-client"
require "json"
require "openssl"

require "omise/account"
require "omise/card"
require "omise/charge"
require "omise/customer"
require "omise/error"
require "omise/list"
require "omise/resource"
require "omise/token"
require "omise/version"

module Omise
  CA_BUNDLE_PATH = File.expand_path("../../data/ca_certificates.pem", __FILE__)

  class << self
    attr_accessor :api_key, :base_url
  end

  self.base_url = "https://api.omise.co/"
end
