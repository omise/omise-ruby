require "support"

class TestRefund < Omise::Test
  setup do
    @refunds = Omise::Charge.retrieve("chrg_test_4yq7duw15p9hdrjp8oq").refunds
    @refund = @refunds.retrieve("rfnd_test_4yqmv79ahghsiz23y3c")
  end

  def test_that_we_can_retrieve_a_refund
    assert_instance_of Omise::Refund, @refund
    assert_equal "rfnd_test_4yqmv79ahghsiz23y3c", @refund.id
  end

  def test_that_we_can_list_all_refunds
    refunds = Omise::Refund.list

    assert refunds
    assert_instance_of Omise::List, refunds
    assert_instance_of Omise::Refund, refunds.first
  end

  def test_that_we_can_create_a_refund
    refund = @refunds.create(amount: 10000)

    assert_instance_of Omise::Refund, refund
    assert_equal "rfnd_test_4yqmv79ahghsiz23y3c", refund.id
  end

  def test_that_a_refund_can_be_reloaded
    @refund.attributes.taint
    @refund.reload

    refute @refund.attributes.tainted?
  end

  def test_that_retrieveing_a_non_existing_refund_will_raise_an_error
    assert_raises Omise::Error do
      @refunds.retrieve("404")
    end
  end

  def test_that_a_refund_belongs_to_a_charge
    assert_instance_of Omise::Charge, @refund.charge
  end

  def test_that_a_refund_has_a_transaction
    assert_instance_of Omise::Transaction, @refund.transaction
  end
end
