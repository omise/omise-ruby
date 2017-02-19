require "support"

class TestConfig < Omise::Test
  def test_that_default_values_are_set
    assert_equal "https://api.omise.co", Omise.api_url
    assert_equal "https://vault.omise.co", Omise.vault_url
  end

  def test_that_default_http_logger_is_set
    assert_instance_of Omise::HTTPLogger, Omise.http_logger
    assert_nil Omise.http_logger.logger
  end

  def test_that_we_can_set_a_logger
    logger = Logger.new(STDOUT)
    Omise.logger = logger

    assert_same logger, Omise.http_logger.logger
  end

  def teardown
    Omise.logger = nil
  end
end
