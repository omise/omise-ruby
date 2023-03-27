require "support"

class TestCharge < Omise::Test
  setup do
    @charge = Omise::Charge.retrieve("chrg_test_4yq7duw15p9hdrjp8oq")
  end

  def test_that_we_can_create_a_charge
    charge = Omise::Charge.create

    assert_instance_of Omise::Charge, charge
    assert_equal "chrg_test_4yq7duw15p9hdrjp8oq", charge.id
  end

  def test_that_we_can_create_a_charge_even_if_api_key_is_nil
    without_keys do
      charge = Omise::Charge.create(key: "skey_test_4yq6tct0lblmed2yp5t")

      assert_instance_of Omise::Charge, charge
      assert_equal "chrg_test_4yq7duw15p9hdrjp8oq", charge.id
    end
  end

  def test_that_we_can_retrieve_a_charge
    assert_instance_of Omise::Charge, @charge
    assert_equal "chrg_test_4yq7duw15p9hdrjp8oq", @charge.id
  end

  def test_that_unexpanded_resource_are_automatically_expanded
    assert_instance_of Omise::Charge, @charge
    assert_instance_of Omise::Customer, @charge.customer
    assert_instance_of Omise::Transaction, @charge.transaction
    assert_instance_of Omise::RefundList, @charge.refunds
  end

  def test_that_we_can_retrieve_an_expanded_charge
    charge = Omise::Charge.retrieve("chrg_test_4yq7duw15p9hdrjp8oq", expand: true)

    assert_instance_of Omise::Charge, charge
    assert_equal "chrg_test_4yq7duw15p9hdrjp8oq", @charge.id

    assert_instance_of Omise::Customer, @charge.customer
    assert_instance_of Omise::Transaction, @charge.transaction
    assert_instance_of Omise::RefundList, @charge.refunds
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
    @charge.attributes.frozen?
    @charge.reload

    refute @charge.attributes.frozen?
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

  def test_that_paid_return_the_value_of_captured
    captured_charge = Omise::Charge.new(JSON.load('{ "captured": true }'))
    uncaptured_charge = Omise::Charge.new(JSON.load('{ "captured": false }'))

    assert_instance_of TrueClass, captured_charge.captured
    assert_instance_of TrueClass, captured_charge.paid

    assert_instance_of FalseClass, uncaptured_charge.captured
    assert_instance_of FalseClass, uncaptured_charge.paid
  end

  def test_that_captured_return_the_value_of_paid
    paid_charge = Omise::Charge.new(JSON.load('{ "paid": true }'))
    unpaid_charge = Omise::Charge.new(JSON.load('{ "paid": false }'))

    assert_instance_of TrueClass, paid_charge.paid
    assert_instance_of TrueClass, paid_charge.captured

    assert_instance_of FalseClass, unpaid_charge.paid
    assert_instance_of FalseClass, unpaid_charge.captured
  end

  def test_that_we_can_send_a_capture_request
    assert @charge.capture
  end

  def test_that_we_can_send_a_reverse_request
    assert @charge.reverse
  end

  def test_that_we_can_set_a_charge_to_expire
    assert @charge.expire
  end

  def test_that_search_returns_a_scoped_search
    assert_instance_of Omise::SearchScope, Omise::Charge.search
    assert_equal "charge", Omise::Charge.search.scope
  end

  def test_that_schedule_returns_a_scheduler
    assert_instance_of Omise::Scheduler, Omise::Charge.schedule
    assert_equal "charge", Omise::Charge.schedule.type
  end

  def test_that_we_can_fetch_an_event_list_for_a_given_charge
    events = @charge.events

    assert events
    assert_instance_of Omise::List, events
  end
end
