require "omise/attributes"
require "omise/resource"

module Omise
  class OmiseObject
    include Attributes

    class << self
      attr_accessor :endpoint

      def location(id = nil)
        [endpoint, id].compact.join("/")
      end

      def resource(path, attributes = {})
        key = attributes.delete(:key) { resource_key }
        preprocess_attributes!(attributes)
        Resource.new(resource_url, path, key)
      end

      private

      def singleton!
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
        Omise.api_key
      end
    end

    private

    def resource(*args)
      self.class.resource(location, *args)
    end
  end
end
