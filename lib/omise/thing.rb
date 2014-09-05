require "omise/resource"

module Omise
  class Thing
    extend Omise::Resource::Methods

    def initialize(attributes = {})
      @attributes = attributes
    end

    attr_reader :attributes

    def self.typecast(object)
      klass = begin
        Omise.const_get(object["object"].capitalize)
      rescue NameError
        Thing
      end

      klass.new(object)
    end

    def update(attributes = {})
      object = Omise::Resource.new(location).update(attributes)
      assign_attributes(object)
    end

    def destroy(attributes = {})
      @attributes = Omise::Resource.new(location).destroy(attributes)
      assign_attributes(object)
    end

    def assign_attributes(object)
      if object["object"] == @attributes["object"]
        @attributes = object
        true
      else
        false
      end
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
        @attributes[key.to_s] = Omise::Thing.typecast(value)
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
end
