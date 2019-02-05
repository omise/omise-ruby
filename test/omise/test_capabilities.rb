require "support"

class TestCapabilities < Omise::Test
  setup do
    @capabilities = Omise::Capabilities.retrieve
    backends = @capabilities.backends
    p backends.select{ |b| b['type'] == 'installment' }
  end

  def test_that_we_can_retrieve_the_account
    assert_instance_of Omise::Capabilities, @capabilities
    assert_equal "/capability", @capabilities.location
  end

end
