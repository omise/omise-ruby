require "omise/object"

module Omise
  # An {Occurrence} represents the tick of a clock, if the {Schedule} represents
  # the clock. Everytime a schedule is run, an occurrence will be created and it
  # will carry information about expected date of execution, actual date of
  # execution, wether the execution of the schedule failed, succeeded or
  # was skipped, etc.
  #
  # See https://www.omise.co/occurrences-api for more information regarding the
  # occurrences attributes, the available endpoints and the different parameters
  # each endpoint accepts.
  #
  class Occurrence < OmiseObject
    self.endpoint = "/occurrences"

    # Retrieves an occurrence object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/occurrences/OCCURRENCE_ID
    #
    # Example:
    #
    #     occurrence = Omise::Occurrence.retrieve(occurrence_id)
    #
    # Returns a new {Occurrence} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.retrieve(id, params = {})
      client.get(location(id), params: params)
    end

    # Typecasts or expands the schedule attached to an occurrence if
    # it's present.
    #
    # Calling this method may issue a single HTTP request if the schedule was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/schedules/SCHEDULE_ID
    #
    # Example:
    #
    #     occurrence = Omise::Occurrence.retrieve(occurrence_id)
    #     schedule   = occurrence.schedule
    #
    # Returns a new {Schedule} instance if successful, nil if there's no
    # schedule or raises an {Error} if the request fails.
    #
    def schedule(params = {})
      if !defined?(Schedule)
        require "omise/schedule"
      end

      expand_attribute Schedule, "schedule", params
    end

    # Reloads an existing occurrence.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/occurrences/OCCURRENCE_ID
    #
    # Example:
    #
    #     occurrence = Omise::Occurrence.retrieve(occurrence_id)
    #     occurrence.reload
    #
    # Returns the same {Occurrence} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes client.get(location, params: params, as: Hash)
    end
  end
end
