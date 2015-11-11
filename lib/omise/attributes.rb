require "omise/util"

module Omise
  # The {Attributes} module provides a way to dynamically dispatch methods so
  # that we're able to lookup the values inside of the `@attributes` hash as if
  # they were methods directly defined on an object.
  #
  # A class which wishes to implement this module must at the very minimum set
  # the `@attributes` instance variable to a kind of Hash like so:
  #
  #     class Teapot
  #       include Omise::Attributes
  #
  #       def initialize(attributes = {})
  #         @attributes = attributes
  #       end
  #     end
  #
  #     teapot = Teapot.new("color" => "white")
  #     teapot.color # => white
  #
  # Note that at this time the key of the attributes hash must be string.
  #
  module Attributes
    # Returns the original attributes.
    #
    attr_reader :attributes

    # Replaces the existing attributes and cleanup the object.
    #
    # Returns self.
    #
    def assign_attributes(attributes = {})
      cleanup!
      @attributes = attributes
      yield if block_given?
      self
    end

    # Gets the current location if no ID is given. Or generates a new location
    # path based on the object location joined with a given ID.
    #
    # Returns a `String`.
    #
    def location(id = nil)
      [@attributes["location"], id].compact.join("/")
    end

    # Returns true if an object has been deleted, false otherwise.
    #
    def destroyed?
      @attributes["deleted"]
    end

    # Retrieves the value from attributes corresponding to the given key. If
    # the value is a `Hash`, the value will be typecasted to one of the
    # {OmiseObject} subclasses (see {Util.typecast}).
    #
    # Returns an object.
    #
    def [](key)
      value = @attributes[key.to_s]
      if value.is_a?(Hash)
        Omise::Util.typecast(value)
      else
        value
      end
    end

    # Returns true if the key is present in the object attributes,
    # false otherwise.
    #
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

    # Returns true if we are able to dynamically respond to a given method call.
    #
    def respond_to_missing?(method_name, *args, &block)
      if predicate?(method_name)
        true
      elsif key?(method_name)
        true
      else
        super
      end
    end

    # Dynamically dispatch a method call to lookup the attributes hash.
    #
    # Returns the value if it was found, raises `NoMethodError` otherwise.
    #
    def method_missing(method_name, *args, &block)
      if predicate?(method_name)
        !!self[method_name.to_s.chomp("?")]
      elsif key?(method_name)
        self[method_name]
      else
        super
      end
    end

    # Returns the hash representation of the object to be turned into a
    # JSON object.
    #
    def as_json(*)
      @attributes
    end

    private

    def list_attribute(klass, key)
      klass.new(@attributes[key], parent: self)
    end

    def expand_attribute(object, key, options = {})
      if @attributes[key] && @attributes[key].is_a?(String)
        expanded_attributes[key] ||= object.retrieve(@attributes[key], options)
      else
        self[key]
      end
    end

    def expanded_attributes
      @expanded_attributes ||= {}
    end

    def cleanup!
      @expanded_attributes = {}
    end
  end
end
