require "omise/config"
require "omise/attributes"

module Omise
  class OmiseObject
    include Attributes

    def initialize(attributes = {}, options = {})
      @attributes = attributes
      @options    = options
    end

    class << self
      attr_accessor :endpoint

      def location(id = nil)
        [endpoint, id].compact.join("/")
      end

      def resource(path, attributes = {})
        key = attributes.delete(:key) { resource_key }
        preprocess_attributes!(attributes)
        Omise.resource.new(resource_url, path, key)
      end

      private

      def collection
        self
      end

      def singleton!
        require "omise/singleton_resource"
        include SingletonResource
      end

      def preprocess_attributes!(attributes)
        if attributes[:card].is_a?(Hash)
          require "omise/token"
          card_attributes = attributes.delete(:card)
          attributes[:card] = Token.create(card: card_attributes).id
        end
      end

      def resource_url
        Omise.api_url
      end

      def resource_key
        Omise.secret_api_key
      end
    end

    private

    def collection
      self.class
    end

    def resource(*args)
      collection.resource(location, *args)
    end

    def nested_resource(path, *args)
      collection.resource([location, path].compact.join("/"), *args)
    end

    def list_nested_resource(klass, key, options = {})
      if @attributes.key?(key) && options.empty?
        return list_attribute(klass, key)
      end

      klass.new(nested_resource(key, options).get, parent: self)
    end
  end
end
