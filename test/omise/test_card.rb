require "support"

class TestCard < Minitest::Test
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
    @customer.destroy
  end

  def test_the_endpoint
    assert_equal "cards", Omise::Card.endpoint
  end

  def test_that_we_can_retrieve
    card = @customer.cards.retrieve(@customer.cards.first.id)

    assert_kind_of Omise::OmiseObject, card
    assert_instance_of Omise::Card, card
    assert_equal "card", card.attributes["object"]
  end

  def test_that_we_can_create
    card = @customer.cards.create({
      number: "4242424242424242",
      expiration_year: "2019",
      expiration_month: "10",
      name: "ROBIN CLART",
      security_code: "123"
    })
    @customer.reload

    assert_equal 2, @customer.cards.total
    assert_equal "card", card.attributes["object"]
  end

  def test_that_we_can_reload
    card = @customer.cards.first
    same_card = @customer.cards.retrieve(card.id)
    same_card.update(name: "ROBIN J CLART")
    card.reload

    refute_equal same_card.object_id, card.object_id
    assert_equal "ROBIN J CLART", card.name
  end

  def test_that_we_can_update
    card = @customer.cards.first
    card.update(name: "ROBIN J CLART")

    assert_equal "ROBIN J CLART", card.name
    assert_equal "ROBIN J CLART", @customer.cards.retrieve(card.id).name
  end

  def test_that_we_can_destroy
    @customer.cards.first.destroy
    @customer.reload

    assert_equal 0, @customer.cards.total
  end
end
