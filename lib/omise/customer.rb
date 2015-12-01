require "omise/object"
require "omise/list"
require "omise/card_list"

module Omise
  class Customer < OmiseObject
    self.endpoint = "/customers"

    def self.retrieve(id = nil, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
    end

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end

    def default_card(options = {})
      expand_attribute cards, "default_card", options
    end

    def cards(options = {})
      if options.empty?
        list_attribute CardList, "cards"
      else
        response = collection.resource(location("cards")).get(options)
        CardList.new(self, response)
      end
    end
  end
end
