module Omise
  class Resource
    module ClassMethods
      def all
        Omise.resource(path).get do |response|
          typecast JSON.load(response)
        end
      end

      def find(id = nil)
        Omise.resource(path(id)).get do |response|
          typecast JSON.load(response)
        end
      end

      def create(attributes = {})
        Omise.resource(path).post(attributes) do |response|
          typecast JSON.load(response)
        end
      end

      def path(id = nil)
        [endpoint, id].compact.join("/")
      end

      def typecast(object)
        klass = begin
          Omise.const_get(object["object"].capitalize)
        rescue NameError
          Resource
        end

        klass.new(object)
      end
    end

    module InstanceMethods
      def update(attributes = {})
        Omise.resource(location).patch(attributes) do |response|
          assign_attributes JSON.load(response)
        end
      end

      def destroy
        Omise.resource(location).destroy do |response|
          assign_attributes JSON.load(response)
        end
      end

      def assign_attributes(object)
        if object["object"] == @attributes["object"]
          @attributes = object
          true
        else
          false
        end
      end
    end

    module Attributes
      def initialize(attributes = {})
        @attributes = attributes
      end

      def attributes
        @attributes
      end

      def location
        @attributes["location"]
      end

      def destroyed?
        @attributes["deleted"]
      end

      def as_json(*)
        @attributes
      end

      def [](key)
        value = @attributes[key.to_s]
        if value.is_a?(Hash)
          @attributes[key.to_s] = self.class.typecast(value)
        else
          value
        end
      end

      def key?(key)
        @attributes.key?(key.to_s)
      end

      def respond_to?(method_name)
        key?(method_name) || super
      end

      def method_missing(method_name, *args, &block)
        if key?(method_name)
          self[method_name]
        else
          super
        end
      end
    end

    extend ClassMethods
    include InstanceMethods
    include Attributes
  end
end
