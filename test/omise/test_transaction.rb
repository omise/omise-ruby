require "support"

class TestTransaction < Minitest::Test
  def setup
    @transaction = Omise::Transaction.retrieve("trxn_test_4yq7duwb9jts1vxgqua")
  end

  def test_that_we_can_retrieve_a_transaction
    assert_instance_of Omise::Transaction, @transaction
    assert_equal "trxn_test_4yq7duwb9jts1vxgqua", @transaction.id
  end

  def test_that_we_can_list_all_transaction
    transactions = Omise::Transaction.list

    assert_instance_of Omise::List, transactions
  end
end
