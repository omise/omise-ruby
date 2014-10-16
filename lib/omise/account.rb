require "omise/object"
require "omise/singleton_resource"

module Omise
  class Account < OmiseObject
    self.endpoint = "account"
    singleton!
  end
end
