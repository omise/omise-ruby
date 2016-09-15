require "support"

class TestSearchScope < Omise::Test
  def test_that_we_can_typecast_a_simple_object
    object = Omise::Util.typecast({})

    assert_instance_of Omise::OmiseObject, object
  end

  def test_that_we_can_typecast_a_recognized_omise_object
    charge = Omise::Util.typecast({ "object" => "charge" })

    assert_instance_of Omise::Charge, charge
  end

  def test_that_we_can_load_an_object_from_a_json_response
    response = JSON.dump({})
    object = Omise::Util.load_response(response)

    assert_instance_of Hash, object
  end

  def test_that_an_exception_is_raised_when_a_json_response_comes_back_as_an_error
    response = JSON.dump({
      "object"  => "error",
      "code"    => "not_found",
      "message" => "the request object was not found",
    })

    error = assert_raises(Omise::Error) { Omise::Util.load_response(response) }
    assert_equal "the request object was not found (not_found)", error.message
    assert_equal "not_found", error.code
  end

  def test_that_we_can_generate_a_query
    assert_equal "hash[key]=value",
      CGI.unescape(Omise::Util.generate_query(hash: { key: "value" }))
    assert_equal "hash[key][key]=value",
      CGI.unescape(Omise::Util.generate_query(hash: { key: { key: "value" } }))
    assert_equal "array[]=1&array[]=2",
      CGI.unescape(Omise::Util.generate_query(array: [1, 2]))
    assert_equal "namespace[]=1&namespace[]=2",
      CGI.unescape(Omise::Util.generate_query([1, 2], "namespace"))
    assert_equal "string=hello",
      CGI.unescape(Omise::Util.generate_query(string: "hello"))
    assert_equal "number=1",
      CGI.unescape(Omise::Util.generate_query(number: 1))
    assert_equal "boolean=true",
      CGI.unescape(Omise::Util.generate_query(boolean: true))
    assert_equal "boolean=false",
      CGI.unescape(Omise::Util.generate_query(boolean: false))
    assert_equal "missing=",
      CGI.unescape(Omise::Util.generate_query(missing: nil))

    # Putting it all together
    assert_equal "array[]=a&array[]=b&boolean[no]=false&boolean[yes]=true&hash[key][key]=value&missing=&string=hello",
      CGI.unescape(Omise::Util.generate_query({
        array:   ["a", "b"],
        boolean: { no: false, yes: true },
        hash:    { key: { key: "value" } },
        missing: nil,
        string:  "hello",
      }))
  end
end
