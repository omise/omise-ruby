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
    def reload(params = {})
      assign_attributes client.get(location, params: params, as: Hash)
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
    def update(params = {})
      assign_attributes client.patch(location, params: params, as: Hash)
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
    def destroy
      assign_attributes client.delete(location, as: Hash)
    end
  end
end
