require "omise/list"
require "omise/refund"

module Omise
  class RefundList < List
    def create(attributes = {})
      Refund.new self.class.resource(location, attributes).post(attributes)
    end

    def retrieve(id, attributes = {})
      Refund.new self.class.resource(location(id), attributes).get(attributes)
    end
  end
end
