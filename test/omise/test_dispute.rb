require "support"

class TestDispute < Minitest::Test
  def setup
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

  def test_that_we_can_update_a_charge
    @dispute.update(message: "Your dispute message")

    assert_equal @dispute.message, "Your dispute message"
  end
end
