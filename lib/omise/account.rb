require "uri"
require "openssl"
require "rest-client"

require "omise/object"
require "omise/util"
require "omise/version"

module Omise
  # {Account} allows you to retrieve an Omise account. Note that the `/account`
  # endpoint is a singleton resource. But this class isn't a singleton and each
  # account object that you fetch will have it's own object_id.
  #
  # Example:
  #
  #     Omise.api_key = OMISE_API_KEY
  #     account = Omise::Account.retrieve
  #
  # Alternatively if you have mutliple accounts you can retrieve all of them
  # separately by using {Account.with_credentials} then calling reload. Note
  # that {with_credentials} won't automatically fetch the attributes for you.
  #
  #     accounts = keys.map do |key|
  #       begin
  #         Omise::Account.with_credentials(secret_api_key: key).reload
  #       rescue Omise::Error => e
  #         # deal with exception accordingly
  #         nil
  #       end
  #     end.compact
  #
  class Account < OmiseObject
    self.endpoint = "/account"

    CA_BUNDLE_PATH = File.expand_path("../../../data/ca_certificates.pem", __FILE__)
    DEFAULT_HEADERS = {
      omise_version: "2015-11-17",
      user_agent:    "OmiseRuby/#{Omise::VERSION} Ruby/#{RUBY_VERSION}",
    }

    def initialize(attributes = {}, options = {})
      @credentials = extract_credentials!(options)
      @configuration = extract_configuration!(options)

      super(attributes, options)
    end

    # Initializes a new {Account} with the given secret and public api keys.
    # Note that the attributes are not automatically fetched from the server and
    # you will have to call {Account#reload} in order to have access to all the
    # attributes of your account.
    #
    # Example:
    #
    #     account = Omise::Account.with_credentials(secret_api_key: key)
    #     account.reload
    #
    # Returns an instance of {Account}.
    #
    def self.with_credentials(secret_api_key:, public_api_key: nil)
      new({}, { secret_api_key: secret_api_key, public_api_key: public_api_key })
    end

    # Retrieves the current {Account}.
    #
    # Returns an {Account} instance if successful and raises an {Error} if the
    # request fails.
    #
    def self.retrieve(params = {})
      account.get(location, params: params)
    end

    # Reload the account object. Calling this method will issue a single
    # HTTP request:
    #
    #   - GET https://api.omise.co/account
    #
    # Example:
    #
    #     account = Omise::Account.retrieve
    #     account.reload
    #
    # Returns the same {Account} instance with updated attributes if successful 
    # and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes account.get(location, params: params, as: Hash)
    end

    # Gets the parent of the account. Which is always nil.
    #
    # Returns nil.
    #
    def parent
      nil
    end

    # Gets the location of the account which will always be equal to the
    # {Account.endpoint}.
    #
    # Returns a {String}.
    #
    def location
      self.class.location
    end

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

    def extract_credentials!(options)
      {
        secret_api_key: options.delete(:secret_api_key),
        public_api_key: options.delete(:public_api_key),
      }
    end

    def extract_configuration!(options)
      {
        api_url: options.delete(:api_url),
        vault_url: options.delete(:vault_url),
        user_agent_suffix: options.delete(:user_agent_suffix),
        http_logger: options.delete(:http_logger),
      }
    end

    def get_configuration(name)
      @configuration[name] || Omise.send(name)
    end

    def get_credential(name)
      key = @credentials["#{name}_api_key".to_sym] || Omise.send("#{name}_api_key")

      unless key
        raise "Set Omise.#{name} to use this feature"
      end

      key
    end

    def http_logger
      @configuration[:http_logger]
    end

    def account
      self
    end

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
