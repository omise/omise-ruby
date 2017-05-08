require "omise/object"

module Omise
  class Occurrence < OmiseObject
    self.endpoint = "/occurrences"

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def schedule(options = {})
      if !defined?(Schedule)
        require "omise/schedule"
      end

      expand_attribute Schedule, "schedule", options
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end
  end
end
