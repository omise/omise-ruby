require "uri"
require "openssl"
require "rest-client"

require "omise/util"
require "omise/version"

module Omise
  class Resource
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

    def prepare_headers
      headers = {}.merge(DEFAULT_HEADERS)

      if Omise.api_version
        headers = headers.merge(omise_version: Omise.api_version)
      end

      if Omise.user_agent_suffix
        headers[:user_agent] += ' ' + Omise.user_agent_suffix
      end

      headers
    end
  end
end
