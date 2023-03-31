require "support"

class TestRecipient < Omise::Test
  setup do
    @recipient = Omise::Recipient.retrieve("recp_test_50894vc13y8z4v51iuc")
  end

  def test_that_we_can_retrieve_a_recipient
    assert_instance_of Omise::Recipient, @recipient
    assert_equal "recp_test_50894vc13y8z4v51iuc", @recipient.id
  end

  def test_that_we_can_list_all_recipients
    recipients = Omise::Recipient.list

    assert_instance_of Omise::List, recipients
  end

  def test_that_we_can_update_a_recipient
    @recipient.update(email: "john@doe.com")

    assert_equal "john@doe.com", @recipient.email
  end

  def test_that_we_can_reload_a_recipient
    @recipient.attributes.freeze
    @recipient.reload

    refute @recipient.attributes.frozen?
  end

  def test_that_we_can_destroy_a_recipient
    @recipient.destroy

    assert @recipient.deleted
    assert @recipient.destroyed?
  end

  def test_that_a_recipient_has_a_bank_account
    assert_instance_of Omise::BankAccount, @recipient.bank_account
  end

  def test_that_search_returns_a_scoped_search
    assert_instance_of Omise::SearchScope, Omise::Recipient.search
    assert_equal "recipient", Omise::Recipient.search.scope
  end
end
