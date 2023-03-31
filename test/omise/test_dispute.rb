require "support"

class TestDispute < Omise::Test
  setup do
    @dispute = Omise::Dispute.retrieve("dspt_test_5089off452g5m5te7xs")
  end

  def test_that_we_can_list_all_disputes
    disputes = Omise::Dispute.list

    assert_instance_of Omise::List, disputes
  end

  def test_that_we_can_list_all_open_disputes
    disputes = Omise::Dispute.list(status: :open)

    assert_instance_of Omise::List, disputes
  end

  def test_that_we_can_list_all_pending_disputes
    disputes = Omise::Dispute.list(status: :pending)

    assert_instance_of Omise::List, disputes
  end

  def test_that_we_can_list_all_closed_disputes
    disputes = Omise::Dispute.list(status: :closed)

    assert_instance_of Omise::List, disputes
  end

  def test_that_we_can_retrieve_a_dispute
    assert_instance_of Omise::Dispute, @dispute
    assert_equal "dspt_test_5089off452g5m5te7xs", @dispute.id
  end

  def test_that_we_can_reload_a_dispute
    @dispute.attributes.freeze
    @dispute.reload

    refute @dispute.attributes.frozen?
  end

  def test_that_we_can_update_a_dispute
    @dispute.update(message: "Your dispute message")

    assert_equal @dispute.message, "Your dispute message"
  end

  def test_that_we_can_accept_a_dispute
    @dispute.attributes.freeze

    assert_equal @dispute.status, "open"

    @dispute.accept

    assert_equal @dispute.status, "lost"
    refute @dispute.attributes.frozen?
  end

  def test_that_we_can_retrieve_a_list_of_documents
    assert_instance_of Omise::DocumentList, @dispute.documents
  end

  def test_that_search_returns_a_scoped_search
    assert_instance_of Omise::SearchScope, Omise::Dispute.search
    assert_equal "dispute", Omise::Dispute.search.scope
  end
end
