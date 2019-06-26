require "rubygems"
require "bundler/setup"

Bundler.require(:default, :test)

require "minitest/autorun"

module Omise
  class Test < Minitest::Test
    def before_setup
      Omise.public_api_key = "pkey_test_4yq6tct0llin5nyyi5l"
      Omise.secret_api_key = "skey_test_4yq6tct0lblmed2yp5t"
    end

    def setup
      before_setup
    end

    def self.setup(&block)
      define_method :setup do
        before_setup
        instance_exec(&block)
      end
    end

    private

    def without_keys
      original_public_api_key = Omise.public_api_key
      original_secret_api_key = Omise.secret_api_key

      Omise.public_api_key = nil
      Omise.secret_api_key = nil

      yield

      Omise.public_api_key = original_public_api_key
      Omise.secret_api_key = original_secret_api_key
    end
  end

  class Account
    undef :get, :post, :patch, :delete

    def get(path, params: {}, as: nil, scope: :api)
      typecast(read_file(scope, "get", path, params), klass: as, account: self)
    end

    def post(path, params: {}, as: nil, scope: :api)
      typecast(read_file(scope, "post", path), klass: as, account: self)
    end

    def patch(path, params: {}, as: nil, scope: :api)
      typecast(read_file(scope, "patch", path), klass: as, account: self)
    end

    def delete(path, as: nil, scope: :api)
      typecast(read_file(scope, "delete", path), klass: as, account: self)
    end

    private

    def read_file(scope, verb, path, attributes = {})
      case scope
      when :api
        base_url = get_configuration(:api_url)
      when :vault
        base_url = get_configuration(:vault_url)
      end

      host = uri(base_url, path).host

      if attributes.empty?
        suffix = verb
      else
        params = attributes.to_a.sort { |x,y| x.first.to_s <=> y.first.to_s }.flatten.join("-")
        suffix = [verb, params].compact.join("-")
      end

      File.read(File.expand_path(File.join(
        Omise::LIB_PATH, "..", "test", "fixtures",
        [host, path, "-#{suffix}.json"].join
      )))
    end
  end
end
