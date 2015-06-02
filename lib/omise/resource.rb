require "uri"
require "json"
require "openssl"
require "rest-client"

require "omise/util"
require "omise/config"
require "omise/error"

module Omise
  class Resource
    CA_BUNDLE_PATH = File.expand_path("../../../data/ca_certificates.pem", __FILE__)

    def initialize(url, path, key)
      @uri = URI.parse(url)
      @uri.path = [@uri.path, path].join
      @resource = RestClient::Resource.new(@uri.to_s, {
        user: key,
        verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        ssl_ca_file: CA_BUNDLE_PATH,
        headers: {
          user_agent: "OmiseRuby/#{Omise::VERSION} OmiseAPI/#{Omise.api_version} Ruby/#{RUBY_VERSION}"
        }
      })
    end

    def get(attributes = {})
      @resource.get(attributes) { |r| Omise::Util.load_response(r) }
    end

    def patch(attributes = {})
      @resource.patch(attributes) { |r| Omise::Util.load_response(r) }
    end

    def post(attributes = {})
      @resource.post(attributes) { |r| Omise::Util.load_response(r) }
    end

    def delete
      @resource.delete { |r| Omise::Util.load_response(r) }
    end
  end
end
