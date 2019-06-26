module Omise
  # {HTTPLogger} is responsible for logging requests and responses coming from
  # {Resource} to a given logger. If no logger is given during initalization
  # both {#log_request} and {#log_response} will be noop.
  #
  class HTTPLogger
    LABEL = "[Omise]".freeze

    def initialize(logger = nil)
      @logger = logger
    end

    # Returns the original logger.
    #
    attr_reader :logger

    # Log a request from {Resource} to the logger. Note that the logs are
    # inserted as `INFO`.
    #
    def log_request(request)
      info(format_request(request))
    end

    # Log a response from {Resource} to the logger. Note that the logs are
    # inserted as `INFO`.
    #
    def log_response(response)
      info(format_response(response))
    end

    private

    def info(message)
      return unless @logger

      @logger.info(message)
    end

    def format_request(request)
      StringIO.open do |s|
        s.puts("#{LABEL} Request: #{request.method.to_s.upcase} #{request.url}")
        s.puts(format_headers(request.processed_headers))
        s.puts
        s.puts(format_payload(request.args[:payload])) if request.args[:payload]

        s.string
      end
    end

    def format_response(response)
      net_http = response.net_http_res

      StringIO.open do |s|
        s.puts("#{LABEL} Response: HTTP/#{net_http.http_version} #{net_http.code} #{net_http.message}")
        s.puts(format_headers(net_http.each_capitalized))
        s.puts
        s.puts(response.body)

        s.string
      end
    end

    def format_headers(headers)
      headers.map { |name, value| "#{name}: #{value}" }.join("\n")
    end

    def format_payload(payload)
      payload.map { |key, value| "#{key}=#{value}" }.join("&")
    end
  end
end
