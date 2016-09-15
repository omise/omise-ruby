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

  def test_that_we_can_update_a_dispute
    @dispute.update(message: "Your dispute message")

    assert_equal @dispute.message, "Your dispute message"
  end

  def test_that_search_returns_a_scoped_search
    assert_instance_of Omise::SearchScope, Omise::Dispute.search
    assert_equal "dispute", Omise::Dispute.search.scope
    assert_equal Omise::Dispute::AVAILABLE_SEARCH_FILTERS, Omise::Dispute.search.available_filters
  end
end
