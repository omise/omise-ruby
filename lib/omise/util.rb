require "cgi"
require "json"

require "omise/object"
require "omise/error"

module Omise
  module Util module_function
    def typecast(object)
      klass = begin
        klass_name = object["object"].split("_").map(&:capitalize).join("")
        Omise.const_get(klass_name)
      rescue NameError
        OmiseObject
      end

      klass.new(object)
    end

    def load_response(response)
      object = JSON.load(response)

      if object["object"] == "error"
        raise Omise::Error, object
      end

      object
    end

    def generate_query(object, namespace = nil)
      if object.is_a?(Hash)
        return object.map do |key, value|
          unless (value.is_a?(Hash) || value.is_a?(Array)) && value.empty?
            generate_query(value, namespace ? "#{namespace}[#{key}]" : key)
          end
        end.compact.sort! * "&"
      end

      if object.is_a?(Array)
        prefix = "#{namespace}[]"

        if object.empty?
          return generate_query(nil, prefix)
        else
          return object.map { |value| generate_query(value, prefix) }.join("&")
        end
      end

      "#{CGI.escape(generate_param(namespace))}=#{CGI.escape(generate_param(object).to_s)}"
    end

    def generate_param(object)
      if object.is_a?(Hash)
        return generate_query(object)
      end

      if object.is_a?(Array)
        return object.map { |o| generate_param(o) }.join("/")
      end

      if object.is_a?(NilClass) || object.is_a?(TrueClass) || object.is_a?(FalseClass)
        return object
      end

      object.to_s
    end
  end
end
