module Omise
  # {OccurrenceList} represents a list of occurences. It inherits from {List}
  # and as such can be paginated. This class exposes one additional method to
  # help you retrieve a specific occurence.
  #
  # Example:
  #
  #     schedule   = Omise::Schedule.retrieve(schedule_id)
  #     occurences = schedule.occurences
  #
  # See https://www.omise.co/occurences-api for more information regarding
  # the occurences attributes, the available endpoints and the different
  # parameters each endpoint accepts. And you can find out more about
  # pagination and list options by visiting https://www.omise.co/api-pagination.
  #
  class OccurrenceList < List
    # Retrieves an occurence object.
    #
    # This method is a delegate for {Occurence.retrieve}.
    #
    # Returns a new {Occurence} instance if successful and raises an {Error}
    # if the request fails.
    #
    def retrieve(id, params = {})
      client.get(Occurrence.location(id), params: params)
    end
  end
end
