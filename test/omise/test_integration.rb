require "support"

class TestIntegration < Omise::Test
  setup do
    @integration = Omise::Integration.retrieve("integration_test_5h24qlv37qyx537p1ub")
  end

  def test_that_we_can_retrieve_an_integration
    assert_instance_of Omise::Integration, @integration
    assert_equal "integration_test_5h24qlv37qyx537p1ub", @integration.id
  end
end
