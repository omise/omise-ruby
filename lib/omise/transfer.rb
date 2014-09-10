require "omise/resource"

module Omise
  class Transfer < Resource
    def self.endpoint
      "transfers"
    end
  end
end
