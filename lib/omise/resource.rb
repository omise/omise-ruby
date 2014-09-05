module Omise
  class Resource
    def initialize(path)
      @uri = URI.parse(Omise.base_url)
      @uri.path = [@uri.path, path].join
      @resource = RestClient::Resource.new(@uri.to_s, {
        user: Omise.api_key,
        verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        ssl_ca_file: Omise::CA_BUNDLE_PATH
      })
    end

    def find
      @resource.get do |response,a,b|
        object = JSON.load(response)
        Omise::Thing.typecast(object)
      end
    end

    def create(attributes = {})
      @resource.post(attributes) do |response|
        object = JSON.load(response)
        Omise::Thing.typecast(object)
      end
    end

    def update(attributes = {})
      @resource.patch(attributes) do |response|
        object = JSON.load(response)
        Omise::Thing.typecast(object)
      end
    end

    def destroy(attributes = {})
      @resource.delete(attributes) do |response|
        object = JSON.load(response)
        Omise::Thing.typecast(object)
      end
    end

    module Methods
      def find(id = nil)
        Omise::Resource.new(path(id)).find
      end

      def create(attributes = {})
        Omise::Resource.new(path).create(attributes)
      end

      def path(id = nil)
        [endpoint, id].compact.join("/")
      end
    end
  end
end
