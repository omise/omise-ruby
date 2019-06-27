require "omise/config"

module Omise
  class OmiseObject
    def initialize(attributes = {}, options = {})
      @attributes = attributes
      @options = options
      @expanded_attributes = {}
    end

    class << self
      attr_accessor :endpoint

      def location(id = nil)
        [endpoint, id].compact.join("/")
      end

      def account
        Omise.account
      end
    end

    # Returns the original attributes.
    #
    attr_reader :attributes

    # Replaces the existing attributes and cleanup the object. The cleanup
    # process can be tweaked in each class by reimplementing the {cleanup!}
    # private method.
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
    # {OmiseObject} subclasses (see {typecast}).
    #
    # Returns any object.
    #
    def [](key)
      value = @attributes[key.to_s]

      if value.is_a?(Hash)
        typecast(value)
      else
        value
      end
    end

    # Returns true if the key is present in the object attributes,
    # false otherwise.
    #
    # Returns a boolean.
    #
    def key?(key)
      @attributes.key?(key.to_s)
    end

    # Returns true if the name given as argument is a predicate (ends with a
    # question mark) and a key exist with the same name in the attributes hash.
    #
    # Returns a boolean.
    #
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

    # Responds true if we are able to dynamically respond to a given method
    # call. False otherwise.
    #
    # Returns a boolean.
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
    # Returns a {Hash}.
    #
    def as_json(*)
      @attributes
    end

    # The parent of this object.
    #
    # Returns an {OmiseObject}-like object or nil.
    #
    def parent
      @options[:parent]
    end

    private

    def typecast(object, klass: nil)
      if object.is_a?(String)
        object = JSON.load(object)
      end

      if object["object"] == "error"
        raise Omise::Error, object
      end

      if klass == object.class || object["object"].nil?
        return object
      end

      if klass.nil?
        klass = begin
          klass_name = object["object"].split("_").map(&:capitalize).join("")
          Omise.const_get(klass_name)
        rescue NameError
          OmiseObject
        end
      end

      klass.new(object, account: account, parent: self)
    end

    def list_attribute(klass, key)
      klass.new(@attributes[key], parent: self, account: account)
    end

    def expand_attribute(klass, key, params = {})
      if @attributes[key] && @attributes[key].is_a?(String)
        expanded_attributes[key] ||= klass.retrieve(@attributes[key], params)
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

    def list_nested_resource(klass, key, params = {})
      if @attributes.key?(key) && params.empty?
        return list_attribute(klass, key)
      end

      typecast(account.get(location(key), params: params, as: Hash), klass: klass)
    end

    def account
      @options[:account] || Omise.account
    end
  end
end
