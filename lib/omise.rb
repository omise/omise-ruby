require "rest-client"
require "json"
require "openssl"

require "omise/account"
require "omise/balance"
require "omise/card"
require "omise/charge"
require "omise/customer"
require "omise/error"
require "omise/list"
require "omise/token"
require "omise/transaction"
require "omise/transfer"
require "omise/version"

module Omise
  CA_BUNDLE_PATH = File.expand_path("../../data/ca_certificates.pem", __FILE__)

  class << self
    attr_accessor :api_key, :base_url
  end

  self.base_url = "https://api.omise.co/"

  def self.resource(path)
    @uri = URI.parse(Omise.base_url)
    @uri.path = [@uri.path, path].join
    @resource = RestClient::Resource.new(@uri.to_s, {
      user: Omise.api_key,
      verify_ssl: OpenSSL::SSL::VERIFY_PEER,
      ssl_ca_file: Omise::CA_BUNDLE_PATH
    })
  end
end
