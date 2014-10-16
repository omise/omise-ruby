require "support"

class TestBalance < Minitest::Test
  def test_the_endpoint
    assert_equal "balance", Omise::Balance.endpoint
  end

  def test_that_we_can_retrieve
    balance = Omise::Balance.retrieve
    assert_kind_of Omise::OmiseObject, balance
    assert_instance_of Omise::Balance, balance
    assert_equal "balance", balance.attributes["object"]
  end

  def test_that_we_can_reload
    balance = Omise::Balance.retrieve
    attributes = balance.attributes
    balance.reload

    refute_equal attributes.object_id, balance.attributes.object_id
    assert_equal attributes, balance.attributes
  end
end
