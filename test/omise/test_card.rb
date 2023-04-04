require "support"

class TestCard < Omise::Test
  setup do
    @cards = Omise::Customer.retrieve("cust_test_4yq6txdpfadhbaqnwp3").cards
    @card = @cards.retrieve("card_test_4yq6tuucl9h4erukfl0")
  end

  def test_that_we_can_retrieve_a_card
    assert_instance_of Omise::Card, @card
    assert_equal "card_test_4yq6tuucl9h4erukfl0", @card.id
  end

  def test_that_we_can_create_a_card
    card = @cards.create({
      name: "JOHN DOE",
      number: "4242424242424242",
      expiration_month: "1",
      expiration_year: "2017",
      security_code: "123"
    })

    assert_instance_of Omise::Card, card
    assert_equal "card_test_4yq6tuucl9h4erukfl0", card.id
  end

  def test_that_a_card_can_be_reloaded
    @card.attributes.freeze
    @card.reload

    refute @card.attributes.frozen?
  end

  def test_that_retrieveing_a_non_existing_card_will_raise_an_error
    assert_raises Omise::Error do
      @cards.retrieve("404")
    end
  end

  def test_that_a_card_can_be_updated
    @card.update(name: "JOHN W. DOE")

    assert_equal "JOHN W. DOE", @card.name
  end

  def test_that_a_card_can_be_destroyed
    @card.destroy

    assert @card.destroyed?
    assert @card.deleted
  end
end
