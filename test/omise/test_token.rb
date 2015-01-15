require "support"

class TestToken < Minitest::Test
  def setup
    @token = Omise::Token.retrieve("tokn_test_4yq8lbecl0q6dsjzxr5")
  end

  def test_that_we_can_create_a_token
    token = Omise::Token.create({
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
    @token.attributes.taint
    @token.reload

    refute @token.attributes.tainted?
  end
end
