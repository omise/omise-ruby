module Omise
  class Error < StandardError
    def initialize(attributes = {})
      @code = attributes["code"]
      @message = attributes["message"]
    end

    def to_s
      "#{@message} (#{@code})"
    end
  end
end
