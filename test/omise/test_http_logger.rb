require "support"

class TestHTTPLogger < Omise::Test
  def test_we_can_initialize_a_logger_with_default_log
    http_logger = Omise::HTTPLogger.new

    assert_instance_of Omise::HTTPLogger, http_logger
    assert_nil http_logger.logger
  end

  def test_we_can_initialize_a_logger_setting_a_log
    logger = Logger.new(STDOUT)
    http_logger = Omise::HTTPLogger.new(logger)

    assert_instance_of Omise::HTTPLogger, http_logger
    assert_same logger, http_logger.logger
  end

  def setup
    @log_mock = Minitest::Mock.new
  end

  def test_we_can_log_an_http_request
    request = Struct.new(
      :method,
      :url,
      :processed_headers,
      :args
    ).new(
      :post,
      "http://api.omise.co/path",
      { "Header" => "value" },
      { payload: { var1: "value1", var2: "value2" } },
    )
    expected_log_message = "[Omise] Request: POST http://api.omise.co/path\nHeader: value\n\nvar1=value1&var2=value2\n"
    @log_mock.expect(:info, nil, [expected_log_message])

    Omise::HTTPLogger.new(@log_mock).log_request(request)

    assert @log_mock.verify
  end

  def test_we_can_log_an_http_response
    net_http = Struct.new(
      :http_version,
      :code,
      :message,
      :each_capitalized
    ).new(
      "1.1",
      200,
      "OK",
      [["Header", "value"]]
    )
    response = Struct.new(
      :net_http_res,
      :body
    ).new(
      net_http,
      "Work my body over"
    )
    expected_log_message = "[Omise] Response: HTTP/1.1 200 OK\nHeader: value\n\nWork my body over\n"
    @log_mock.expect(:info, nil, [expected_log_message])

    Omise::HTTPLogger.new(@log_mock).log_response(response)

    assert @log_mock.verify
  end
end
