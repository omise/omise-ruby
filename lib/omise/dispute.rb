require "omise/object"
require "omise/list"
require "omise/document_list"
require "omise/search_scope"

module Omise
  # A {Dispute} in a consumer initiated complain about a charge either because
  # the transaction was fraudulent, or the good was not received, or for other
  # various reasons.
  #
  # See https://www.omise.co/disputes-api for more information regarding
  # the dispute attributes, the available endpoints and the different
  # parameters each endpoint accepts.
  #
  class Dispute < OmiseObject
    self.endpoint = "/disputes"

    # Initializes a search scope that when executed will search through your
    # account's disputes.
    #
    # Example:
    #
    #     results = Omise::Dispute.search
    #       .filter(created: "today")
    #       .execute
    #
    # Returns a {SearchScope} instance.
    #
    def self.search
      SearchScope.new(:dispute)
    end

    # Retrieves a dispute object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/disputes/DISPUTE_ID
    #
    # Example:
    #
    #     dispute = Omise::Dispute.retrieve(dispute_id)
    #
    # Returns a new {Dispute} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.retrieve(id = nil, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    # Retrieves a list of dispute objects.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/disputes
    #
    # By default the list will be returned in chronological order. You can
    # inverse the order to start from the latest disputes in your account by
    # passing `reverse_chronological` to the `order:` option. You can also
    # restrict what disputes will be returned by passing the `from:` and/or
    # `to:` options. Lastly you can paginate the results by using the `offset:`
    # and `limit:` options. You can find out more about pagination and list
    # options by visiting https://www.omise.co/api-pagination.
    #
    # Examples:
    #
    #     # First disputes
    #     disputes = Omise::Dispute.list
    #
    #     # Latest customers
    #     disputes = Omise::Dispute.list(order: "reverse_chronological")
    #
    # Returns a new {List} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.list(attributes = {})
      status = attributes.delete(:status)
      List.new resource(location(status), attributes).get(attributes)
    end

    # Reloads an existing dispute.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/disputes/DISPUTE_ID
    #
    # Example:
    #
    #     dispute = Omise::Customer.retrieve(customer_id)
    #     dispute.reload
    #
    # Returns the same {Dispute} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    # Updates an existing dispute.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - PATCH https://api.omise.co/disputes/DISPUTE_ID
    #
    # Example:
    #
    #     dispute = Omise::Dispute.retrieve(customer_id)
    #     dispute.update(message: "The customer bought the goods and [...]")
    #
    # Returns the same {Dispute} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    # Typecasts or expands the charge attached to a dispute.
    #
    # Calling this method may issue a single HTTP request if the charge was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/charges/CHARGE_ID
    #
    # Example:
    #
    #     charge      = Omise::Charge.retrieve(charge_id)
    #     transaction = charge.transaction
    #
    # Returns a new {Charge} instance if successful or raises an {Error} if the
    # request fails.
    #
    def charge(options = {})
      if !defined?(Charge)
        require "omise/charge"
      end

      expand_attribute Charge, "charge", options
    end

    # List documents attached to this dispute.
    #
    # Calling this method may issue a single HTTP request if any options
    # are passed:
    #
    #   - GET https://api.omise.co/disputes/DISPUTE_ID/documents
    #
    # Examples:
    #
    #     # Simply list all documents without doing any network requests
    #     dispute   = Omise::Dispute.retrieve(dispute_id)
    #     documents = dispute.documents
    #
    #     # Make a network request because some options are present
    #     dispute   = Omise::Dispute.retrieve(dispute_id)
    #     documents = dispute.documents(limit: 1)
    #
    # Returns a new {DocumentList} instance or raises an {Error} if the
    # request fails.
    #
    def documents(options = {})
      list_nested_resource DocumentList, "documents", options
    end
  end
end
