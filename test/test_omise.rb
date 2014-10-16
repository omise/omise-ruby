require "support"

class TestOmise < Minitest::Test
  def test_the_version
    assert_equal "0.0.1", Omise::VERSION
  end
end
