require "omise/list"
require "omise/charge"

module Omise
  class ChargeList < List
    def initialize(parent, attributes = {})
      super(attributes)
      @parent = parent
    end

    def retrieve(id, attributes = {})
      Charge.retrieve(id)
    end
  end
end
