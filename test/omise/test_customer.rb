require "support"

class TestCustomer < Omise::Test
  setup do
    @customer = Omise::Customer.retrieve("cust_test_4yq6txdpfadhbaqnwp3")
  end

  def test_that_we_can_create_a_customer
    customer = Omise::Customer.create

    assert_instance_of Omise::Customer, customer
    assert_equal "cust_test_4yq6txdpfadhbaqnwp3", customer.id
  end

  def test_that_we_can_retrieve_a_customer
    assert_instance_of Omise::Customer, @customer
    assert_equal "cust_test_4yq6txdpfadhbaqnwp3", @customer.id
  end

  def test_that_we_can_list_all_customer
    customers = Omise::Customer.list

    assert_instance_of Omise::List, customers
  end

  def test_that_we_can_update_a_customer
    @customer.update(email: "john.doe.the.second@example.com")

    assert_equal @customer.email, "john.doe.the.second@example.com"
  end

  def test_that_we_can_destroy_a_customer
    @customer.destroy

    assert @customer.deleted
    assert @customer.destroyed?
  end

  def test_that_we_can_reload_a_customer
    @customer.attributes.taint
    @customer.reload

    refute @customer.attributes.tainted?
  end

  def test_that_we_can_charge_a_customer
    charge = @customer.charge(amount: 100000, currency: "THB")

    assert_instance_of Omise::Charge, charge
  end

  def test_that_retrieveing_a_non_existing_customer_will_raise_an_error
    assert_raises Omise::Error do
      Omise::Customer.retrieve("404")
    end
  end

  def test_that_a_customer_has_a_list_of_card
    assert_instance_of Omise::CardList, @customer.cards
  end

  def test_that_a_customer_can_fetch_a_list_of_ordered_cards
    cards = @customer.cards(order: "chronological")
    assert_instance_of Omise::CardList, cards
  end

  def test_that_a_customer_has_a_default_card
    assert_instance_of Omise::Card, @customer.default_card
  end

  def test_that_search_returns_a_scoped_search
    assert_instance_of Omise::SearchScope, Omise::Customer.search
    assert_equal "customer", Omise::Customer.search.scope
    assert_equal Omise::Customer::AVAILABLE_SEARCH_FILTERS, Omise::Customer.search.available_filters
  end
end
