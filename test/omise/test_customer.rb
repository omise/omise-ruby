require "support"

class TestCustomer < Minitest::Test
  def setup
    @customer = Omise::Customer.create({
      email: "robin@omise.co",
      description: "Robin Clart",
      card: {
        number: "4242424242424242",
        expiration_year: "2019",
        expiration_month: "10",
        name: "ROBIN CLART",
        security_code: "123"
      }
    })
  end

  def teardown
    @customer.destroy unless @customer.destroyed?
  end

  def test_the_endpoint
    assert_equal "customers", Omise::Customer.endpoint
  end

  def test_that_we_can_create
    assert_kind_of Omise::OmiseObject, @customer
    assert_instance_of Omise::Customer, @customer
    assert_equal "customer", @customer.attributes["object"]
  end

  def test_that_we_can_retrieve
    customer = Omise::Customer.retrieve(@customer.id)

    assert_kind_of Omise::OmiseObject, customer
    assert_instance_of Omise::Customer, customer
    assert_equal "customer", customer.attributes["object"]
  end

  def test_that_we_can_reload
    customer = Omise::Customer.retrieve(@customer.id)
    customer.update(description: "Robin J. Clart")
    @customer.reload

    refute_equal @customer.object_id, customer.object_id
    assert_equal "Robin J. Clart", @customer.description
  end

  def test_that_we_can_update
    @customer.update(description: "Robin J. Clart")

    assert_equal "Robin J. Clart", @customer.description
    assert_equal "Robin J. Clart", Omise::Customer.retrieve(@customer.id).description
  end

  def test_that_we_can_destroy
    @customer.destroy

    assert @customer.destroyed?
    assert_raises Omise::Error do
      Omise::Customer.retrieve(@customer.id)
    end
  end

  def test_we_can_get_a_list_of_cards
    assert_kind_of Omise::OmiseObject, @customer.cards
    assert_kind_of Omise::List, @customer.cards
    assert_instance_of Omise::CardList, @customer.cards
  end

  def test_we_can_get_the_default_card
    assert_kind_of Omise::OmiseObject, @customer.default_card
    assert_instance_of Omise::Card, @customer.default_card
  end

  def test_we_even_if_the_default_card_change_we_can_get_it
    @customer.default_card.destroy
    card = @customer.cards.create({
      number: "4242424242424242",
      expiration_year: "2019",
      expiration_month: "10",
      name: "ROBIN CLART",
      security_code: "123"
    })

    assert_equal card.id, @customer.default_card.id
  end
end
