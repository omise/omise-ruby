require "support"

class TestAccount < Minitest::Test
  def test_the_endpoint
    assert_equal "account", Omise::Account.endpoint
  end

  def test_that_we_can_retrieve
    account = Omise::Account.retrieve
    assert_kind_of Omise::OmiseObject, account
    assert_instance_of Omise::Account, account
    assert_equal "account", account.attributes["object"]
  end

  def test_that_we_can_reload
    account = Omise::Account.retrieve
    attributes = account.attributes
    account.reload

    refute_equal attributes.object_id, account.attributes.object_id
    assert_equal attributes, account.attributes
  end
end
