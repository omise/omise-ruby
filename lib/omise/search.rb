require "omise/object"

module Omise
  class Search < OmiseObject
    def self.execute(params = {})
      account.get("/search", params: params)
    end
  end
end
