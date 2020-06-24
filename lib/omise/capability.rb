module Omise
  class Capability < OmiseObject
    self.endpoint = "/capability"

    PaymentMethod = Struct.new(
      :object,
      :name,
      :currencies,
      :card_brands,
      :installment_terms
    )

    # Retrieves the {Capability} object.
    #
    # Returns an {Capability} instance if successful and raises an {Error} if 
    # the request fails.
    #
    def self.retrieve(params = {})
      client.get(location, params: params)
    end

    def payment_methods
      self["payment_methods"].map do |payment_method|
        PaymentMethod.new(
          payment_method["object"],
          payment_method["name"],
          payment_method["currencies"],
          payment_method["card_brands"],
          payment_method["installment_terms"]
        )
      end
    end

    # Gets the location of the capabilities which will always be equal to the
    # {Capability.endpoint}.
    #
    # Returns a {String}.
    #
    def location
      self.class.location
    end
  end
end
