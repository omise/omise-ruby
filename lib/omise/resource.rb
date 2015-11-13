require "uri"
require "json"
require "openssl"
require "rest-client"

require "omise/util"
require "omise/config"
require "omise/error"
require "omise/version"

module Omise
  class Resource
    CA_BUNDLE_PATH = File.expand_path("../../../data/ca_certificates.pem", __FILE__)
    DEFAULT_HEADERS = {
      user_agent: "OmiseRuby/#{Omise::VERSION} Ruby/#{RUBY_VERSION}"
    }

    def initialize(url, path, key)
      @uri = prepare_uri(url, path)
      @headers = prepare_headers
      @key = key

      @resource = RestClient::Resource.new(@uri, {
        user: key,
        verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        ssl_ca_file: CA_BUNDLE_PATH,
        headers: @headers,
      })
    end

    attr_reader :uri, :headers, :key

    def get(attributes = {})
      @resource.get(params: attributes) { |r| Omise::Util.load_response(r) }
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

    private

    def prepare_uri(url, path)
      uri = URI.parse(url)
      uri.path = [uri.path, path].join
      uri.to_s
    end

    def prepare_headers
      headers = {}.merge(DEFAULT_HEADERS)

      if Omise.api_version
        headers = headers.merge(omise_version: Omise.api_version)
      end

      headers
    end
  end
end
