require "omise/object"

module Omise
  class Balance < OmiseObject
    self.endpoint = "/balance"
    singleton!
  end
end
