require "omise/list"
require "omise/refund"

module Omise
  class RefundList < List
    def initialize(charge, attributes = {})
      super(attributes)
      @charge = charge
    end

    def create(attributes = {})
      Refund.new self.class.resource(location, attributes).post(attributes)
    end

    def retrieve(id, attributes = {})
      Refund.new self.class.resource(location(id), attributes).get
    end
  end
end
