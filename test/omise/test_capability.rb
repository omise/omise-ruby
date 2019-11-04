require "support"

class TestCapability < Omise::Test
  setup do
    @capability = Omise::Capability.retrieve
    @payment_methods = @capability.payment_methods
  end

  def test_that_we_can_retrieve_capabilities
    assert_instance_of Omise::Capability, @capability
    assert_equal "/capability", @capability.location
  end

  def test_we_have_payment_backends
    assert @payment_methods.is_a?(Array)
    refute @payment_methods.empty?
  end

  def test_that_we_can_list_payment_methods
    payment_method = @payment_methods.first

    assert_instance_of Array, @payment_methods
    assert_instance_of Omise::Capability::PaymentMethod, payment_method
    assert payment_method.respond_to?(:object)
    assert payment_method.respond_to?(:name)
    assert payment_method.respond_to?(:currencies)
    assert payment_method.respond_to?(:card_brands)
    assert payment_method.respond_to?(:installment_terms)
  end
end
