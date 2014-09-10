require "omise/resource"

module Omise
  class Charge < Resource
    def self.endpoint
      "charges"
    end
  end
end
