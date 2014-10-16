require "omise/object"
require "omise/singleton_resource"

module Omise
  class Balance < OmiseObject
    self.endpoint = "balance"
    singleton!
  end
end
