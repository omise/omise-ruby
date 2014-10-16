require "omise/list"

module Omise
  class CardList < List
    def initialize(customer, attributes = {})
      super(attributes)
      @customer = customer
    end

    def retrieve(id, attributes = {})
      Card.new self.class.resource(location(id), attributes).get
    end

    def create(attributes = {})
      token = Token.create(card: attributes)
      @customer.update(card: token.id)
      retrieve(token.card.id)
    end
  end
end
