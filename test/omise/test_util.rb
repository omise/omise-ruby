require "support"

class TestSearchScope < Omise::Test
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
