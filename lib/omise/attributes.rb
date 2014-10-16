module Omise
  module Attributes
    def initialize(attributes = {})
      @attributes = attributes
    end

    def attributes
      @attributes
    end

    def assign_attributes(attributes = {})
      @attributes = attributes
      cleanup!
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
        @attributes[key.to_s] = Omise.typecast(value)
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

    def cleanup!
      # noop
    end
  end
end
