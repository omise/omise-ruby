require "support"

class TestSearch < Omise::Test
  def test_that_we_can_execute_a_search_query
    search = Omise::Search.execute(scope: "charge")

    assert_instance_of Omise::Search, search
    assert_equal "search", search.object
  end
end
