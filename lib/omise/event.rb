require "omise/object"
require "omise/list"

module Omise
  # An {Event} is created every time an action is carried out inside of your
  # Omise account. Those events can be send out to a URL of your choice if you
  # setup a Webhook URL in the dashboard.
  #
  # See https://www.omise.co/api-webhooks to learn more about how webhooks
  # works and how to get started.
  #
  # And see https://www.omise.co/events-api for more information regarding
  # the event attributes, the available endpoints and the different
  # parameters each endpoint accepts.
  #
  class Event < OmiseObject
    self.endpoint = "/events"

    # Retrieves an event object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/events/EVENT_ID
    #
    # Example:
    #
    #     event = Omise::Event.retrieve(event_id)
    #
    # Returns a new {Event} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    # Retrieves a list of events objects.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/events
    #
    # By default the list will be returned in chronological order. You can
    # inverse the order to start from the latest events in your account by
    # passing `reverse_chronological` to the `order:` option. You can also
    # restrict what events will be returned by passing the `from:` and/or
    # `to:` options. Lastly you can paginate the results by using the `offset:`
    # and `limit:` options. You can find out more about pagination and list
    # options by visiting https://www.omise.co/api-pagination.
    #
    # Examples:
    #
    #     # First events
    #     events = Omise::Event.list
    #
    #     # Latest events
    #     events = Omise::Event.list(order: "reverse_chronological")
    #
    # Returns a new {List} instance if successful and raises an {Error} if the
    # request fails.
    #
    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
    end

    # Reloads an existing event.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/events/EVENT_ID
    #
    # Example:
    #
    #     event = Omise::Event.retrieve(event_id)
    #     event.reload
    #
    # Returns the same {Event} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end
  end
end
