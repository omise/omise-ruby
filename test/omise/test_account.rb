require "support"

class TestAccount < Omise::Test
  setup do
    @account = Omise::Account.retrieve
  end

  def test_that_we_can_retrieve_the_account
    assert_instance_of Omise::Account, @account
    assert_equal "/account", @account.location
  end

  def test_that_we_can_reload_the_account
    @account.attributes.freeze
    @account.reload

    refute @account.attributes.frozen?
  end

  def test_that_we_can_update_the_account
    @account.update(zero_interest_installments: true)

    assert @account.zero_interest_installments
  end
end
