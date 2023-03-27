require "support"

class TestReceipt < Omise::Test
  setup do
    @receipt = Omise::Receipt.retrieve("rcpt_5ls0b8zb53qmw3mlvfz")
  end

  def test_that_we_can_list_all_receipts
    receipts = Omise::Receipt.list

    assert receipts
    assert_instance_of Omise::List, receipts
    assert_instance_of Omise::Receipt, receipts.first
  end

  def test_that_we_can_retrieve_a_receipt
    receipt = Omise::Receipt.retrieve("rcpt_5ls0b8zb53qmw3mlvfz")

    assert receipt
    assert_instance_of Omise::Receipt, receipt
  end

  def test_that_we_can_reload_a_receipt
    @receipt.attributes.frozen?
    @receipt.reload

    refute @receipt.attributes.frozen?
  end
end
