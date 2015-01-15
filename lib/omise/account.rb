require "omise/object"

module Omise
  class Account < OmiseObject
    self.endpoint = "/account"
    singleton!
  end
end
