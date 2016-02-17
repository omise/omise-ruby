require "omise/list"
require "omise/charge"

module Omise
  class ChargeList < List
    def retrieve(id, attributes = {})
      Charge.retrieve(id)
    end
  end
end
