require "support"

module Omise
  class Teapot < OmiseObject
  end
end

class TestOmiseObject < Omise::Test
  setup do
    @attributes = JSON.load(JSON.dump({
      object: "teapot",
      name: "Potts",
      location: "/teapots/teap_1",
      deleted: false,
      child: {
        object: "teapot",
        name: "Chip Potts",
        location: "/teapots/teap_2",
        deleted: false,
      }
    }))

    @teapot = Omise::Teapot.new(@attributes)
  end

  def test_that_we_can_create_a_teapot
    assert_instance_of Omise::Teapot, @teapot
    assert_equal "teapot", @teapot.object
  end

  def test_that_the_child_of_a_teapot_is_still_a_teapot
    assert_instance_of Omise::Teapot, @teapot.child
    assert_equal "teapot", @teapot.child.object
  end

  def test_that_we_can_get_the_attributes_of_the_teapot
    assert_equal @attributes, @teapot.attributes
    assert_equal @attributes, @teapot.as_json
  end

  def test_that_we_can_update_the_teapot_attributes
    @teapot.attributes.taint
    @teapot.assign_attributes({})

    refute @teapot.attributes.tainted?
  end

  def test_that_we_can_tell_if_a_teapot_has_not_been_destroyed
    refute @teapot.destroyed?
    refute @teapot.deleted?
  end

  def test_that_we_can_tell_if_a_teapot_has_been_destroyed
    @teapot.assign_attributes(@attributes.merge("deleted" => true))

    assert @teapot.destroyed?
    assert @teapot.deleted?
  end

  def test_we_can_predicate_any_key
    assert @teapot.child?
  end

  def test_we_cannot_predicate_a_key_not_present
    assert_raises NoMethodError do
      @teapot.color?
    end
  end

  def test_that_we_get_the_location_of_the_teapot
    assert_equal "/teapots/teap_1", @teapot.location
    assert_equal "/teapots/teap_1/child", @teapot.location("child")
  end

  def test_that_we_can_access_an_attributes_value_with_the_square_bracket_accessor
    assert_equal "Potts", @teapot["name"]
    assert_nil @teapot["color"]
    assert_instance_of Omise::Teapot, @teapot["child"]
  end

  def test_that_we_can_tell_if_a_key_is_present_in_the_attributes
    assert @teapot.key?("name")
    refute @teapot.key?("color")
  end

  def test_that_a_teapot_respond_correctly_to_dynamic_method_names
    assert @teapot.respond_to?("name")
    refute @teapot.respond_to?("color")
  end

  def test_that_a_teap_respond_correctly_to_dynamic_predicates
    assert @teapot.respond_to?("deleted?")
    refute @teapot.respond_to?("revoked?")
  end
end
