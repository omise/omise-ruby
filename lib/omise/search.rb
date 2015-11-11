require "omise/object"

module Omise
  class Search < OmiseObject
    def self.execute(attributes = {})
      new resource("/search", attributes).get(attributes)
    end
  end
end
