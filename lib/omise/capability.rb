require "omise/object"

module Omise
  class Capability < OmiseObject
    self.endpoint = "/capability"
    singleton!

    PaymentMethod = Struct.new(
      :object,
      :name,
      :currencies,
      :card_brands,
      :installment_terms
    )

    def self.resource_key
      Omise.public_api_key
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
  end
end
