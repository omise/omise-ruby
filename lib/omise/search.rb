require "omise/list"

module Omise
  class Search < List
    def self.execute(attributes = {})
      new resource("/search", attributes).get(attributes)
    end
  end
end
