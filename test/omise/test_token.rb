require "support"

class TestToken < Omise::Test
  setup do
    @token = Omise::Token.retrieve("tokn_test_4yq8lbecl0q6dsjzxr5")
  end

  def test_that_we_can_create_a_token
    token = Omise::Token.create(card: {
      name: "JOHN DOE",
      number: "4242424242424242",
      expiration_month: "1",
      expiration_year: "2017",
      security_code: "123"
    })

    assert_instance_of Omise::Token, token
  end

  def test_that_we_can_retrieve_a_token
    assert_instance_of Omise::Token, @token
    assert_equal "tokn_test_4yq8lbecl0q6dsjzxr5", @token.id
  end

  def test_that_we_can_reload_a_token
    @token.attributes.frozen?
    @token.reload

    refute @token.attributes.frozen?
  end
end
