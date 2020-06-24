module Omise
  # A {Forex} object represents the foreign exchange rate that will be applied
  # if you create a charge that uses a different currency than your account
  # funding currency.
  #
  # See https://www.omise.co/multi-currency to learn more about how
  # multi-currency works.
  #
  # And see https://www.omise.co/forex-api for more information regarding
  # the forex attributes, the available endpoints and the different
  # parameters each endpoint accepts.
  #
  class Forex < OmiseObject
    self.endpoint = "/forex"

    # Retrieves the exchange rate betweeen the given currency and your account
    # funding currency.
    #
    # Beware that this isn't a quote and is given as an indicative rate. Omise 
    # does not guarantee the rate will be the same when creating a charge.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/forex/CURRENCY
    #
    # Example:
    #
    #     forex = Omise::Forex.from("USD")
    #
    # Returns a new {Forex} instance if successful and raises an {Error} if
    # the request fails.
    #
    def self.from(currency, params = {})
      client.get(location(currency.to_s.downcase), params: params)
    end

    # Reloads an existing forex between the `from` currency and your account
    # funding currency.
    #
    # Note that the foreign exchange rate will remain the same for about
    # ten minutes.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/forex/CURRENCY
    #
    # Example:
    #
    #     forex = Omise::Forex.from("USD")
    #     forex.reload
    #
    # Returns the same {Forex} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes client.get(location, params: params, as: Hash)
    end
  end
end
