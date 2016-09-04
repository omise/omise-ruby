require "omise/util"

module Omise
  module Attributes
    def initialize(attributes = {})
      @expanded_attributes = {}
      @attributes = attributes
    end

    def attributes
      @attributes
    end

    def assign_attributes(attributes = {})
      cleanup!
      @attributes = attributes
      yield if block_given?
      self
    end

    def location(id = nil)
      [@attributes["location"], id].compact.join("/")
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
        Omise::Util.typecast(value)
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

    private

    def lookup_attribute_value(*keys)
      keys.each { |key| return self[key] if key?(key) }
    end

    def list_attribute(klass, key)
      klass.new(self, @attributes[key])
    end

    def list_nested_resource(klass, key, options = {})
      if @attributes.key?(key) && options.empty?
        return list_attribute(klass, key)
      end

      klass.new(self, nested_resource(key, options).get)
    end

    def expand_attribute(object, key, options = {})
      if @attributes[key] && @attributes[key].is_a?(String)
        @expanded_attributes[key] ||= object.retrieve(@attributes[key], options)
      else
        self[key]
      end
    end

    def cleanup!
      @expanded_attributes = {}
    end
  end
end
