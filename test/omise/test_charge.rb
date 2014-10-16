require "support"

class TestCharge < Minitest::Test
  def setup
    @charge_attributes = {
      amount: rand(100000),
      currency: "thb",
      return_uri: "https://www.omise.co/",
      card: {
        number: "4242424242424242",
        expiration_year: "2019",
        expiration_month: "10",
        name: "ROBIN CLART",
        security_code: "123"
      }
    }
  end

  def test_the_endpoint
    assert_equal "charges", Omise::Charge.endpoint
  end

  def test_that_we_can_create
    charge = Omise::Charge.create(@charge_attributes)

    assert_kind_of Omise::OmiseObject, charge
    assert_instance_of Omise::Charge, charge
    assert_equal "charge", charge.attributes["object"]
  end

  def test_that_we_can_retrieve
    charge_id = Omise::Charge.create(@charge_attributes).id
    charge = Omise::Charge.retrieve(charge_id)

    assert_kind_of Omise::OmiseObject, charge
    assert_instance_of Omise::Charge, charge
    assert_equal "charge", charge.attributes["object"]
  end

  def test_that_we_can_reload
    charge = Omise::Charge.create(@charge_attributes)
    same_charge = Omise::Charge.retrieve(charge.id)
    same_charge.update(description: "charge for order 1")
    charge.reload

    refute_equal same_charge.object_id, charge.object_id
    assert_equal "charge for order 1", charge.description
  end

  def test_that_we_can_update
    charge = Omise::Charge.create(@charge_attributes)
    charge.update(description: "charge for order 1")

    assert_equal "charge for order 1", charge.description
    assert_equal "charge for order 1", Omise::Charge.retrieve(charge.id).description
  end
end
