require "uri"
require "openssl"
require "rest-client"

require "omise/util"
require "omise/version"

module Omise
  module Resource
    CA_BUNDLE_PATH = File.expand_path("../../../data/ca_certificates.pem", __FILE__)
    DEFAULT_HEADERS = {
      omise_version: "2015-11-17",
      user_agent:    "OmiseRuby/#{Omise::VERSION} Ruby/#{RUBY_VERSION}",
    }

    def get(path, params: {}, as: nil, scope: :api)
      if params.any?
        uri = URI.parse(path)
        uri.query = Omise::Util.generate_query(params)
        path = uri.to_s
      end

      resource(scope, path).get do |response, request|
        log(request, response)
        typecast(response, klass: as)
      end
    end

    def patch(path, params: {}, as: nil, scope: :api)
      resource(scope, path).patch(params) do |response, request|
        log(request, response)
        typecast(response, klass: as)
      end
    end

    def post(path, params: {}, as: nil, scope: :api)
      resource(scope, path).post(params) do |response, request|
        log(request, response)
        typecast(response, klass: as)
      end
    end

    def delete(path, as: nil, scope: :api)
      resource(scope, path).delete do |response, request|
        log(request, response)
        typecast(response, klass: as)
      end
    end

    private

    def resource(scope, path)
      case scope
      when :api
        base_url = get_configuration(:api_url)
        key = get_credential(:secret)
      when :vault
        base_url = get_configuration(:vault_url)
        key = get_credential(:public)
      end

      RestClient::Resource.new(uri(base_url, path).to_s, {
        user: key,
        verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        ssl_ca_file: CA_BUNDLE_PATH,
        headers: headers,
      })
    end

    def log(request, response)
      get_configuration(:http_logger).log_request(request)
      get_configuration(:http_logger).log_response(response)
    end

    def uri(base_url, path)
      URI.parse(base_url).tap do |uri|
        path  = URI.parse(path)
        query = path.query

        path.query = nil
        uri.path   = [uri.path, path.to_s].join
        uri.query  = query
      end
    end

    def headers
      headers = {}.merge(DEFAULT_HEADERS)

      if get_configuration(:user_agent_suffix)
        headers[:user_agent] += ' ' + get_configuration(:user_agent_suffix)
      end

      headers
    end
  end
end
