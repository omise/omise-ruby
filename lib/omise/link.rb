module Omise
  # A {Link} gives you a url to a payment page to which you can redirect your
  # customer to. The link API accepts attributes similar to the charge API.
  #
  # See https://www.omise.co/links-api for more information regarding the link
  # attributes, the available endpoints and the different parameters each
  # endpoint accepts.
  #
  class Link < OmiseObject
    self.endpoint = "/links"

    # Initializes a search scope that when executed will search through your
    # account's links.
    #
    # Example:
    #
    #     results = Omise::Link.search
    #       .filter(used: true)
    #       .execute
    #
    # Returns a {SearchScope} instance.
    #
    def self.search
      SearchScope.new(:link)
    end

    # Retrieves a link object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/links/LINK_ID
    #
    # Example:
    #
    #     link = Omise::Link.retrieve(link_id)
    #
    # Returns a new {Link} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.retrieve(id, params = {})
      client.get(location(id), params: params)
    end

    # Retrieves a list of links objects.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/links
    #
    # By default the list will be returned in chronological order. You can
    # inverse the order to start from the latest links in your account by
    # passing `reverse_chronological` to the `order:` option. You can also
    # restrict what links will be returned by passing the `from:` and/or
    # `to:` options. Lastly you can paginate the result by using the `offset:`
    # and `limit:` options. You can find out more about pagination and list
    # options by visiting https://www.omise.co/api-pagination.
    #
    # Examples:
    #
    #     # First links
    #     links = Omise::Link.list
    #
    #     # Latest links
    #     links = Omise::Link.list(order: "reverse_chronological")
    #
    # Returns a new {List} instance if successful and raises an {Error} if the
    # request fails.
    #
    def self.list(params = {})
      client.get(location, params: params)
    end

    # Creates a new link.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/links
    #
    # Example:
    #
    #     link = Omise::Link.create({
    #       amount:      250_00,
    #       currency:    "thb",
    #       title:       "Blue T-Shirt",
    #       description: "A 100% cotton blue T-Shirt.",
    #     })
    #
    # Returns a new {Link} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.create(params = {})
      client.post(location, params: params)
    end

    # Reloads an existing link.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/links/LINK_ID
    #
    # Example:
    #
    #     link = Omise::Link.retrieve(link_id)
    #     link.reload
    #
    # Returns the same {Link} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes client.get(location, params: params, as: Hash)
    end

    # List charges attached to a link.
    #
    # Calling this method may issue a single HTTP request if any options
    # are passed:
    #
    #   - GET https://api.omise.co/links/LINK_ID/charges
    #
    # Examples:
    #
    #     # Simply list all charges without doing any network requests
    #     link    = Omise::Link.retrieve(link_id)
    #     charges = link.charges
    #
    #     # Make a network request because some options are present
    #     link    = Omise::Link.retrieve(link_id)
    #     charges = link.charges(limit: 100)
    #
    # Returns a new {ChargeList} instance or raises an {Error} if the
    # request fails.
    #
    def charges(params = {})
      list_nested_resource ChargeList, "charges", params
    end
  end
end
