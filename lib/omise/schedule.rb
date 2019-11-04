require "omise/object"
require "omise/list"
require "omise/occurrence_list"

module Omise
  class Schedule < OmiseObject
    self.endpoint = "/schedules"

    # Retrieves a list of schedule objects.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/schedules
    #
    # By default the list will be returned in chronological order. You can
    # inverse the order to start from the latest schedules in your account by
    # passing `reverse_chronological` to the `order:` option. You can also
    # restrict what schedules will be returned by passing the `from:` and/or
    # `to:` options. Lastly you can paginate the result by using the `offset:`
    # and `limit:` options. You can find out more about pagination and list
    # options by visiting https://www.omise.co/api-pagination.
    #
    # Examples:
    #
    #     # First schedules
    #     schedules = Omise::Schedule.list
    #
    #     # Latest schedules
    #     schedules = Omise::Schedule.list(order: "reverse_chronological")
    #
    # Returns a new {List} instance if successful and raises an {Error} if the
    # request fails.
    #
    def self.list(params = {})
      account.get(location, params: params)
    end

    # Retrieves a schedule object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/schedules/SCHEDULE_ID
    #
    # Example:
    #
    #     schedule = Omise::Schedule.retrieve(schedule_id)
    #
    # Returns a new {Schedule} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.retrieve(id, params = {})
      account.get(location(id), params: params)
    end

    # Creates a new schedule.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/schedules
    #
    # Example:
    #
    #     schedule = Omise::Schedule.create({
    #       every:      2,
    #       period:     "day",
    #       start_date: "2017-05-01",
    #       end_date:   "2018-05-01",
    #       charge: {
    #         customer: "cust_test_57m2wcnfx96k634rkqq",
    #         amount:   100000,
    #       },
    #     })
    #
    # Returns a new {Charge} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.create(params = {})
      account.post(location, params: params)
    end

    # Delete the schedule.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - DELETE https://api.omise.co/schedules/SCHEDULE_ID
    #
    # Example:
    #
    #     schedule = Omise::Schedule.retrieve(schedule_id)
    #     schedule.destroy
    #
    # Returns the same {Schedule} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def destroy
      assign_attributes account.delete(location, as: Hash)
    end

    # Checks whether or not the schedule has been destroyed.
    #
    # Returns a boolean.
    #
    def destroyed?
      status == "deleted"
    end

    # List occurrences attached to this schedule.
    #
    # Calling this method may issue a single HTTP request if any options
    # are passed:
    #
    #   - GET https://api.omise.co/schedules/SCHEDULE_ID/occurrences
    #
    # Examples:
    #
    #     # Simply list all occurrences without doing any network requests
    #     schedule    = Omise::Schedule.retrieve(schedule_id)
    #     occurrences = schedule.occurrences
    #
    #     # Make a network request because some options are present
    #     schedule    = Omise::Schedule.retrieve(schedule_id)
    #     occurrences = schedule.occurrences(expand: true)
    #
    # Returns a new {OccurrenceList} instance or raises an {Error} if the
    # request fails.
    #
    def occurrences(params = {})
      list_nested_resource OccurrenceList, "occurrences", params
    end
  end
end
