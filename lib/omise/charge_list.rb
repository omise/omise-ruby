require "omise/list"
require "omise/charge"

module Omise
  # {CardList} represents a list of charges. It inherits from {List} and as
  # such can be paginated. This class exposes one additional method to help
  # you retrieve a charge.
  #
  # Example:
  #
  #     link    = Omise::Link.retrieve(link_id)
  #     charges = link.charges
  #
  # See https://www.omise.co/charges-api for more information regarding
  # the charge attributes, the available endpoints and the different parameters
  # each endpoint accepts. And you can find out more about pagination and list
  # options by visiting https://www.omise.co/api-pagination.
  #
  class ChargeList < List
    # Retrieves a charge object.
    #
    # This method is a delegate for {Charge.retrieve}.
    #
    # Returns a new {Charge} instance if successful and raises an {Error} if the
    # request fails.
    #
    def retrieve(id, attributes = {})
      Charge.retrieve(id, attributes)
    end
  end
end
