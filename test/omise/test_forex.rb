require "support"

class TestForex < Omise::Test
  setup do
    @forex = Omise::Forex.from("USD")
  end

  def test_that_we_can_retrieve_a_forex
    forex = Omise::Forex.from("usd")

    assert_instance_of Omise::Forex, forex
  end

  def test_that_we_can_retrieve_a_forex_by_passing_symbol
    forex = Omise::Forex.from(:usd)

    assert_instance_of Omise::Forex, forex
  end

  def test_that_we_can_reload_a_forex
    @forex.attributes.taint
    @forex.reload

    refute @forex.attributes.tainted?
  end
end
