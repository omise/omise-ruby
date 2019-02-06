require "support"

class TestCapabilities < Omise::Test
  setup do
    @capabilities = Omise::Capabilities.retrieve
    @payment_backends = @capabilities.payment_backends
  end

  def test_that_we_can_retrieve_capabilities
    assert_instance_of Omise::Capabilities, @capabilities
    assert_equal "/capability", @capabilities.location
  end

  def test_we_have_payment_backends
    assert @payment_backends.is_a?(Array)
    refute @payment_backends.empty?
  end

  def test_backends_have_ids
    assert @payment_backends.all? { |backend| backend.key?("id") }
  end

end
