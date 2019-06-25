require "omise/list"

module Omise
  # A {RefundList} represents a list of refunds. It inherits from {List} and as
  # such can be paginated. This class exposes two additional methods to help
  # you create and retrieve refunds.
  #
  # Example:
  #
  #     charge  = Omise::Charge.retrieve(charge_id)
  #     refunds = charge.refunds
  #
  # See https://www.omise.co/refunds-api for more information regarding
  # the charge attributes, the available endpoints and the different parameters
  # each endpoint accepts. And you can find out more about pagination and list
  # options by visiting https://www.omise.co/api-pagination.
  #
  class RefundList < List
    # Creates a new refund.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/charges/CHARGE_ID/refunds
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     refund = charge.refunds.create(amount: 100000)
    #
    # Returns a new {Refund} instance if successful and raises an {Error} if
    # the request fails.
    #
    def create(params = {})
      account.post(location, params: params)
    end

    # Retrieves a refund object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/charges/CHARGE_ID/refunds/REFUND_ID
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     refund = charge.refunds.retrieve(refund_id)
    #
    # Returns a new {Refund} instance if successful and raises an {Error} if
    # the request fails.
    #
    def retrieve(id, params = {})
      account.get(location(id), params: params)
    end
  end
end
