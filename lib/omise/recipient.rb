require "omise/object"
require "omise/list"
require "omise/search_scope"

module Omise
  # A {Recipient} represents a person who holds one bank account. Recipient can
  # be passed to the {Transfer.create} method in order to transfer some amount
  # of money to the recipient's bank account.
  #
  # See https://www.omise.co/recipients-api for more information regarding
  # the recipient attributes, the available endpoints and the different
  # parameters each endpoint accepts.
  #
  class Recipient < OmiseObject
    self.endpoint = "/recipients"

    # Initializes a search scope that when executed will search through your
    # account's recipients.
    #
    # Example:
    #
    #     results = Omise::Recipient.search
    #       .filter(created: "today")
    #       .execute
    #
    # Returns a {SearchScope} instance.
    #
    def self.search
      SearchScope.new(:recipient)
    end

    # Retrieves a recipient object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/recipients/RECIPIENT_ID
    #
    # Example:
    #
    #     recipient = Omise::Recipient.retrieve(recipient_id)
    #
    # Returns a new {Recipient} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    # Retrieves a list of recipient objects.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/recipients
    #
    # By default the list will be returned in chronological order. You can
    # inverse the order to start from the latest recipients in your account by
    # passing `reverse_chronological` to the `order:` option. You can also
    # restrict what recipient will be returned by passing the `from:` and/or
    # `to:` options. Lastly you can paginate the results by using the `offset:`
    # and `limit:` options. You can find out more about pagination and list
    # options by visiting https://www.omise.co/api-pagination.
    #
    # Examples:
    #
    #     # First recipients
    #     recipients = Omise::Recipient.list
    #
    #     # Latest recipients
    #     recipient = Omise::Recipient.list(order: "reverse_chronological")
    #
    # Returns a new {List} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
    end

    # Creates a new recipient.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/recipients
    #
    # Example:
    #
    #     recipient = Omise::Recipient.create({
    #       name: "Somchai Prasert",
    #       email: "somchai.prasert@example.com",
    #       type: "individual",
    #       bank_account: {
    #         brand: "bbl",
    #         number: "1234567890",
    #         name: "SOMCHAI PRASERT"
    #       }
    #     })
    #
    # Returns a new {Recipient} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

    # Reloads an existing recipient.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/recipients/RECIPIENT_ID
    #
    # Example:
    #
    #     recipient = Omise::Recipient.retrieve(recipient_id)
    #     recipient.reload
    #
    # Returns the same {Recipient} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    # Updates an existing recipient.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - PATCH https://api.omise.co/recipients/RECIPIENT_ID
    #
    # Example:
    #
    #     recipient = Omise::Recipient.retrieve(recipient_id)
    #     recipient.update(name: "Somchai")
    #
    # Returns the same {Recipient} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    # Destroys an existing recipient.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - DELETE https://api.omise.co/recipients/RECIPIENT_ID
    #
    # Example:
    #
    #     recipient = Omise::Recipient.retrieve(recipient_id)
    #     recipient.destroy
    #     recipient.destroyed? # => true
    #
    # Returns the same {Recipient} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end

    # Typecasts the bank account attached to the recipient.
    #
    # Calling this method won't issue any HTTP request since the bank account
    # object will always be auto expanded by default.
    #
    # Since it is not possible for recipient to be created without a valid bank
    # account this method should always return a bank account.
    #
    # Example:
    #
    #     recipient    = Omise::Recipient.retrieve(recipient_id)
    #     bank_account = recipient.bank_account
    #
    # Returns a new {BankAccount} instance.
    #
    def bank_account
      if !defined?(BankAccount)
        require "omise/bank_account"
      end

      expand_attribute BankAccount, "bank_account"
    end
  end
end
