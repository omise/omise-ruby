require "omise/object"
require "omise/card_list"

module Omise
  class Customer < OmiseObject
    self.endpoint = "/customers"

    def self.retrieve(id = nil, attributes = {})
      if id.nil?
        List.new resource(location, attributes).get
      else
        new resource(location(id), attributes).get
      end
    end

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get
    end

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end

    def default_card(options = {})
      if @attributes["default_card"]
        @default_card ||= cards.retrieve(@attributes["default_card"], options)
      end
    end

    def cards
      @cards ||= CardList.new(self, @attributes["cards"])
    end

    private

    def cleanup!
      @default_card = nil
      @cards = nil
    end
  end
end
