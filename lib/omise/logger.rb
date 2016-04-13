module Omise
  class Logger
    LABEL = "[Omise]".freeze

    attr_reader :log

    def initialize(log = nil)
      @log = log
    end

    def log_request(request)
      return unless log

      message = StringIO.open do |s|
        s.puts("#{LABEL} Request: #{request.method.to_s.upcase} #{request.url}")
        append_headers(s, request.processed_headers)
        s.puts(format_payload(request.args[:payload])) if request.args[:payload]
        s.string
      end

      log.info(message)
    end

    def log_response(response)
      return unless log

      net_http = response.net_http_res

      message = StringIO.open do |s|
        s.puts("#{LABEL} Response: HTTP/#{net_http.http_version} #{net_http.code} #{net_http.message}")
        append_headers(s, net_http.each_capitalized)
        s.puts(response.body)
        s.string
      end

      log.info(message)
    end

    private

    def append_headers(message, headers)
      headers.each do |name, value|
        message.puts("#{name}: #{value}")
      end

      message.puts
    end

    def format_payload(payload)
      payload.map { |key, value| "#{key}=#{value}" }.join("&")
    end
  end
end
