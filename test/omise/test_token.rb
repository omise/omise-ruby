require "support"

class TestToken < Minitest::Test
  def setup
    @card_attributes = {
      card: {
        number: "4242424242424242",
        expiration_year: "2019",
        expiration_month: "10",
        name: "ROBIN CLART",
        security_code: "123"
      }
    }
  end

  def test_that_we_can_create
    token = Omise::Token.create(@card_attributes)

    assert_kind_of Omise::OmiseObject, token
    assert_instance_of Omise::Token, token
    assert_equal "token", token.attributes["object"]
  end

  def test_that_we_can_retrieve
    token_id = Omise::Token.create(@card_attributes).id
    token = Omise::Token.retrieve(token_id)

    assert_kind_of Omise::OmiseObject, token
    assert_instance_of Omise::Token, token
    assert_equal "token", token.attributes["object"]
  end

  def test_that_we_can_reload
    token = Omise::Token.create(@card_attributes)
    attributes = token.attributes
    token.reload

    refute_equal attributes.object_id, token.attributes.object_id
    assert_equal attributes, token.attributes
  end
end
