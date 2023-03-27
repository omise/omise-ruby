require "support"

class TestBalance < Omise::Test
  setup do
    @balance = Omise::Balance.retrieve
  end

  def test_that_we_can_retrieve_the_balance
    assert_instance_of Omise::Balance, @balance
    assert_equal "/balance", @balance.location
  end

  def test_that_we_can_reload_a_customer
    @balance.attributes.frozen?
    @balance.reload

    refute @balance.attributes.frozen?
  end
end
