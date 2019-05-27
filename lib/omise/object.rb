require "omise/config"
require "omise/attributes"

module Omise
  class OmiseObject
    include Attributes

    class << self
      attr_accessor :endpoint
      attr_accessor :options

      def location(id = nil)
        [endpoint, id].compact.join("/")
      end

      def resource(path, attributes = {})
        @options = {
          key: attributes.delete(:key) { resource_key }
        }

        preprocess_attributes!(attributes)
        Omise.resource.new(resource_url, path, @options[:key])
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
      collection.resource(location, *prepare_args(args))
    end

    def nested_resource(path, *args)
      collection.resource([location, path].compact.join("/"), *prepare_args(args))
    end

    # Update args to include current object#options
    def prepare_args(args)
      args[0] = @options.merge(args[0])

      args
    end
  end
end
