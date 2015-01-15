require "support"

class TestBalance < Minitest::Test
  def setup
    @balance = Omise::Balance.retrieve
  end

  def test_that_we_can_retrieve_the_balance
    assert_instance_of Omise::Balance, @balance
    assert_equal "/balance", @balance.location
  end

  def test_that_we_can_reload_a_customer
    @balance.attributes.taint
    @balance.reload

    refute @balance.attributes.tainted?
  end
end
