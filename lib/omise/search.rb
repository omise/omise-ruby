require "omise/object"

module Omise
  class Search < OmiseObject
    def self.execute(params = {})
      client.get("/search", params: params)
    end
  end
end
