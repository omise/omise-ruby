require "support"

class TestCharge < Minitest::Test
  def setup
    @charge = Omise::Charge.retrieve("chrg_test_4yq7duw15p9hdrjp8oq")
  end

  def test_that_we_can_create_a_charge
    charge = Omise::Charge.create

    assert_instance_of Omise::Charge, charge
    assert_equal "chrg_test_4yq7duw15p9hdrjp8oq", charge.id
  end

  def test_that_we_can_retrieve_a_charge
    assert_instance_of Omise::Charge, @charge
    assert_equal "chrg_test_4yq7duw15p9hdrjp8oq", @charge.id
  end

  def test_that_we_can_list_all_charge
    charges = Omise::Charge.list

    assert_instance_of Omise::List, charges
  end

  def test_that_we_can_update_a_charge
    @charge.update(description: "Charge for order 3947 (XXL)")

    assert_equal @charge.description, "Charge for order 3947 (XXL)"
  end

  def test_that_we_can_reload_a_charge
    @charge.attributes.taint
    @charge.reload

    refute @charge.attributes.tainted?
  end

  def test_that_retrieveing_a_non_existing_charge_will_raise_an_error
    assert_raises Omise::Error do
      Omise::Charge.retrieve("404")
    end
  end

  def test_that_a_customer_has_a_transaction
    assert_instance_of Omise::Transaction, @charge.transaction
  end

  def test_that_a_customer_has_a_default_card
    assert_instance_of Omise::Customer, @charge.customer
  end

  def test_that_we_can_retrieve_a_list_of_refunds
    assert_instance_of Omise::RefundList, @charge.refunds
  end
end
