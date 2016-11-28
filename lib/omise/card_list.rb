require "omise/list"

module Omise
  class CardList < List
    def retrieve(id, attributes = {})
      if !defined?(Card)
        require "omise/card"
      end

      Card.new self.class.resource(location(id), attributes).get(attributes)
    end

    def create(attributes = {})
      if !defined?(Token)
        require "omise/token"
      end

      token = Token.create(card: attributes)
      parent.update(card: token.id)
      retrieve(token.card.id)
    end
  end
end
