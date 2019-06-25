require "support"

class TestAccount < Omise::Test
  setup do
    @account = Omise::Account.retrieve
  end

  def test_that_we_can_retrieve_the_account
    assert_instance_of Omise::Account, @account
    assert_equal "/account", @account.location
  end

  def test_that_we_can_reload_an_account
    @account.attributes.taint
    @account.reload

    refute @account.attributes.tainted?
  end
end
