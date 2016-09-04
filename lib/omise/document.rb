require "omise/object"

module Omise
  class Document < OmiseObject
    self.endpoint = "/documents"

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end
  end
end
