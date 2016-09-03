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
      user_agent: "OmiseRuby/#{Omise::VERSION} Ruby/#{RUBY_VERSION}",
    }

    def initialize(url, path, key)
      @uri     = prepare_uri(url, path)
      @headers = prepare_headers
      @key     = key

      set_resource
    end

    attr_reader :uri, :headers, :key

    def get(attributes = {})
      if attributes.any?
        @uri.query = Omise::Util.generate_query(attributes)
        set_resource
      end

      @resource.get { |r| Omise::Util.load_response(r) }
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

    def set_resource
      @resource = RestClient::Resource.new(@uri.to_s, {
        user: @key,
        verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        ssl_ca_file: CA_BUNDLE_PATH,
        headers: @headers,
      })
    end

    def prepare_uri(url, path)
      URI.parse(url).tap do |uri|
        path  = URI.parse(path)
        query = path.query

        path.query = nil
        uri.path   = [uri.path, path.to_s].join
        uri.query  = query
      end
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
