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
      raise Omise::Error.new(object) if object["object"] == "error"
      object
    end
  end
end
