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

    # Issues a single GET request.
    #
    # The full URL will be built based on the scope which can either be `:api`
    # or `:vault` and the path given as first argument. The scope determines
    # which configuration url from the account is used. If the scope is `:api`,
    # then the `api_url` will be used. On the other hand, if the `:vault` scope
    # is used, then the vault_url will be used. Those two URLs can be
    # configured either when instantiating a new account or directly on the
    # {Omise} module.
    #
    # You can pass an `as:` option to this method to coerce the response into a
    # specific class. The default is nil, which will automatically typecast the
    # response if possible. Otherwise a barebone `OmiseObject` will be
    # returned. You can also pass Hash if you want a raw ruby hash.
    #
    # The account which initiated the request will be injected into the
    # response object unless the response object is a Hash.
    #
    # The params will be converted to a query string.
    #
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

    # Issues a single POST request.
    #
    # The full URL will be built based on the scope which can either be `:api`
    # or `:vault` and the path given as first argument. The scope determines
    # which configuration url from the account is used. If the scope is `:api`,
    # then the `api_url` will be used. On the other hand, if the `:vault` scope
    # is used, then the vault_url will be used. Those two URLs can be
    # configured either when instantiating a new account or directly on the
    # {Omise} module.
    #
    # You can pass an `as:` option to this method to coerce the response into a
    # specific class. The default is nil, which will automatically typecast the
    # response if possible. Otherwise a barebone `OmiseObject` will be
    # returned. You can also pass Hash if you want a raw ruby hash.
    #
    # The account which initiated the request will be injected into the
    # response object unless the response object is a Hash.
    #
    # The params will sent as JSON in the body of the request.
    #
    def post(path, params: {}, as: nil, scope: :api)
      resource(scope, path).post(params) do |response, request|
        log(request, response)
        typecast(response, klass: as)
      end
    end

    # Issues a single PATCH request.
    #
    # The full URL will be built based on the scope which can either be `:api`
    # or `:vault` and the path given as first argument. The scope determines
    # which configuration url from the account is used. If the scope is `:api`,
    # then the `api_url` will be used. On the other hand, if the `:vault` scope
    # is used, then the vault_url will be used. Those two URLs can be
    # configured either when instantiating a new account or directly on the
    # {Omise} module.
    #
    # The params will sent as JSON in the body of the request.
    #
    # You can pass an `as:` option to this method to coerce the response into a
    # specific class. The default is nil, which will automatically typecast the
    # response if possible. Otherwise a barebone `OmiseObject` will be
    # returned. You can also pass Hash if you want a raw ruby hash.
    #
    # The account which initiated the request will be injected into the
    # response object unless the response object is a Hash.
    #
    def patch(path, params: {}, as: nil, scope: :api)
      resource(scope, path).patch(params) do |response, request|
        log(request, response)
        typecast(response, klass: as)
      end
    end

    # Issues a single DELETE request.
    #
    # The full URL will be built based on the scope which can either be `:api`
    # or `:vault` and the path given as first argument. The scope determines
    # which configuration url from the account is used. If the scope is `:api`,
    # then the `api_url` will be used. On the other hand, if the `:vault` scope
    # is used, then the vault_url will be used. Those two URLs can be
    # configured either when instantiating a new account or directly on the
    # {Omise} module.
    #
    # You can pass an `as:` option to this method to coerce the response into a
    # specific class. The default is nil, which will automatically typecast the
    # response if possible. Otherwise a barebone `OmiseObject` will be
    # returned. You can also pass Hash if you want a raw ruby hash.
    #
    # The account which initiated the request will be injected into the
    # response object unless the response object is a Hash.
    #
    # No params can be sent using this method.
    #
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
