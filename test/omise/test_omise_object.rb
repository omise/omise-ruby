require "support"

module Omise
  class Kettle < OmiseObject
    def self.retrieve(id, attributes = {})
      resource(id, attributes)

      # stub data
      new({
        object: "kettle",
        teapot: "teapot_1"
      })
    end

    def collection
      @mock ||= MiniTest::Mock.new
    end

    def update(attributes)
      resource(attributes)
    end

    def teapot(mock)
      expand_attribute mock, :teapot, {}
    end
  end
end

class TestOmiseObject < Omise::Test
  def assert_api_key(expected_key)
    mock = MiniTest::Mock.new
    mock.expect(:retrieve, nil, [
      "teapot_1",
      expected_key
    ])
    yield(mock)

    mock.verify
  end

  def test_that_child_object_should_use_parent_api_key_when_specified
    test_key = "pkey_test_1"
    kettle   = Omise::Kettle.retrieve("/test_1", key: test_key)

    # child object use the same key as parent
    assert_api_key(key: test_key) do |mock|
      kettle.teapot(mock)
    end
  end

  def test_that_subsequent_call_without_api_key_should_use_original_api_key
    # change key
    test_key = "pkey_test_1"
    kettle   = Omise::Kettle.retrieve("/test_1", key: test_key)

    assert_api_key(key: test_key) do |mock|
      kettle.teapot(mock)
    end

    # call without key should use original key
    kettle   = Omise::Kettle.retrieve("/test_1")
    assert_api_key(key: Omise.secret_api_key) do |mock|
      kettle.teapot(mock)
    end
  end

  def test_that_instance_method_should_use_parent_api_key
    test_key = "pkey_test_1"
    location = "/test_1"
    kettle   = Omise::Kettle.retrieve(location, key: test_key)

    # instance method should uses the same key as parent
    kettle.collection.expect(:resource, nil, [
      "", { name: "Teapot", key: test_key }
    ])
    kettle.update(name: "Teapot")
  end
end