require "support"

class TestAccount < Minitest::Test
  def setup
    @account = Omise::Account.retrieve
  end

  def test_that_we_can_retrieve_the_account
    assert_instance_of Omise::Account, @account
    assert_equal "/account", @account.location
  end

  def test_that_we_can_reload_a_customer
    @account.attributes.taint
    @account.reload

    refute @account.attributes.tainted?
  end
end
