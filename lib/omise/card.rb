require "omise/object"

module Omise
  # {Card} represents a debit or credit card. Cards can either be associated to
  # a charge as a one time use card or to a customer for multiple use. Cards
  # that are not attached to a customer have no location and no customer
  # referenced in their attributes.
  #
  # Example:
  #
  #     customer = Omise::Customer.retrieve(customer_id)
  #     card = customer.cards.first
  #
  class Card < OmiseObject
    self.endpoint = "/cards"

    # Reload the card object. Calling this method will issue a single
    # HTTP request:
    #
    #   - GET https://api.omise.co/customers/CUSTOMER_ID/cards/CARD_ID
    #
    # Note that this method will only work if the card is attached to a
    # customer and the location attribute is present.
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     card = customer.cards.first
    #     card.reload
    #
    # Returns the same {Card} instance with updated attributes if successful and
    # raises an {Error} if the request fails.
    #
    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    # Update the card object. Calling this method will issue a single
    # HTTP request:
    #
    #   - PATCH https://api.omise.co/customers/CUSTOMER_ID/cards/CARD_ID
    #
    # Note that this method will only work if the card is attached to a
    # customer and the location attribute is present.
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     card = customer.cards.first
    #     card.update(expiration_month: 12, expiration_year: 2018)
    #
    # Returns the same {Card} instance with updated attributes if successful and
    # raises an {Error} if the request fails.
    #
    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    # Delete the card object. Calling this method will issue a single
    # HTTP request:
    #
    #   - DELETE https://api.omise.co/customers/CUSTOMER_ID/cards/CARD_ID
    #
    # Note that this method will only work if the card is attached to a
    # customer and the location attribute is present.
    #
    # Example:
    #
    #     customer = Omise::Customer.retrieve(customer_id)
    #     card = customer.cards.first
    #     card.destroy
    #
    # Returns the same {Card} instance with updated attributes if successful and
    # raises an {Error} if the request fails.
    #
    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end
  end
end
