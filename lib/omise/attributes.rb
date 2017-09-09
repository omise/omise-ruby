require "omise/util"

module Omise
  module Attributes
    def initialize(attributes = {}, options = {})
      @attributes          = attributes
      @options             = options
      @expanded_attributes = {}
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

    def predicate?(method_name)
      method_name   = method_name.to_s
      question_mark = method_name.chars.last == "?"
      key           = method_name.chomp("?")

      if question_mark && key?(key)
        true
      else
        false
      end
    end

    def respond_to_missing?(method_name, *args, &block)
      if predicate?(method_name)
        true
      elsif key?(method_name)
        true
      else
        super
      end
    end

    def method_missing(method_name, *args, &block)
      if predicate?(method_name)
        !!self[method_name.to_s.chomp("?")]
      elsif key?(method_name)
        self[method_name]
      else
        super
      end
    end

    private

    def list_attribute(klass, key)
      klass.new(@attributes[key], parent: self)
    end

    def list_nested_resource(klass, key, options = {})
      if @attributes.key?(key) && options.empty?
        return list_attribute(klass, key)
      end

      klass.new(nested_resource(key, options).get, parent: self)
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
