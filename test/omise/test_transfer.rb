require "support"

class TestTransfer < Minitest::Test
  def setup
    @transfer = Omise::Transfer.retrieve("trsf_test_4yqacz8t3cbipcj766u")
  end

  def test_that_we_can_create_a_transfer
    transfer = Omise::Transfer.create

    assert_instance_of Omise::Transfer, @transfer
  end

  def test_that_we_can_retrieve_a_transfer
    assert_instance_of Omise::Transfer, @transfer
    assert_equal "trsf_test_4yqacz8t3cbipcj766u", @transfer.id
  end

  def test_that_we_can_list_all_transfer
    transfers = Omise::Transfer.list

    assert_instance_of Omise::List, transfers
  end
end
