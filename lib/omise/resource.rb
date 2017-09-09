require "uri"
require "openssl"
require "rest-client"

require "omise/util"
require "omise/version"

module Omise
  class Resource
    CA_BUNDLE_PATH = File.expand_path("../../../data/ca_certificates.pem", __FILE__)
    DEFAULT_HEADERS = {
      omise_version: "2015-11-17",
      user_agent:    "OmiseRuby/#{Omise::VERSION} Ruby/#{RUBY_VERSION}",
    }

    def initialize(url, path, key)
      @uri     = prepare_uri(url, path)
      @headers = {}.merge(DEFAULT_HEADERS)
      @key     = key

      set_resource
    end

    attr_reader :uri, :headers, :key

    def get(attributes = {})
      if attributes.any?
        @uri.query = Omise::Util.generate_query(attributes)
        set_resource
      end

      @resource.get do |response, request|
        log(request, response)
        Omise::Util.load_response(response)
      end
    end

    def patch(attributes = {})
      @resource.patch(attributes) do |response, request|
        log(request, response)
        Omise::Util.load_response(response)
      end
    end

    def post(attributes = {})
      @resource.post(attributes) do |response, request|
        log(request, response)
        Omise::Util.load_response(response)
      end
    end

    def delete
      @resource.delete do |response, request|
        log(request, response)
        Omise::Util.load_response(response)
      end
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

    def log(request, response)
      Omise.http_logger.log_request(request)
      Omise.http_logger.log_response(response)
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
  end
end
