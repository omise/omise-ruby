require "omise/list"

module Omise
  # {CardList} represents a list of cards. It inherits from {List} and as such
  # can be paginated. This class exposes two additional methods to help your
  # create and retrieve customer's cards.
  #
  # Example:
  #
  #     customer = Omise::Customer.retrieve(user.customer_id)
  #     cards    = customer.cards
  #
  # See https://www.omise.co/cards-api for more information regarding the card
  # attributes, the available endpoints and the different parameters each
  # endpoint accepts. And you can find out more about pagination and list
  # options by visiting https://www.omise.co/api-pagination.
  #
  class CardList < List
    # Retrieves a card object that belongs to the customer object that
    # initially fetched the list.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/customers/CUSTOMER_ID/cards/CARD_ID
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     card = customer.cards.retrieve(card_id)
    #
    # Note that it's probably easier to iterate over all the cards instead since
    # the request to retrieve a customer will already hold a list of cards.
    #
    # Returns a new {Card} instance if successful and raises an {Error} if the
    # request fails.
    #
    def retrieve(id, attributes = {})
      if !defined?(Card)
        require "omise/card"
      end

      Card.new self.class.resource(location(id), attributes).get(attributes)
    end

    # Creates a card object that will belong to the customer object that
    # initially fetched the list.
    #
    # Calling this method will issue three HTTP requests:
    #
    #   - POST  https://vault.omise.co/tokens
    #   - PATCH https://api.omise.co/customers/CUSTOMER_ID
    #   - GET   https://api.omise.co/customers/CUSTOMER_ID/cards/CARD_ID
    #
    # Note that in order to call this method you need {Omise.public_api_key} to
    # be set with your Omise public key. You can find this key in the Dashboard.
    #
    # You must have been cleared as a PCI compliant company before using this
    # method in production. You can contact our support at support@omise.co
    # for more information.
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     card     = customer.cards.create(omise_card_attributes)
    #
    # Returns a new {Card} instance if successful and raises an {Error} if one
    # of the requests fails.
    #
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
