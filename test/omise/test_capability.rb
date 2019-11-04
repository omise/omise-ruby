require "support"

class TestCapability < Omise::Test
  setup do
    @capability = Omise::Capability.retrieve
    @payment_backends = @capability.payment_backends
  end

  def test_that_we_can_retrieve_capabilities
    assert_instance_of Omise::Capability, @capability
    assert_equal "/capability", @capability.location
  end

  def test_we_have_payment_backends
    assert @payment_backends.is_a?(Array)
    refute @payment_backends.empty?
  end
end
