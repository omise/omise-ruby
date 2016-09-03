module Omise
  class Error < StandardError
    def initialize(attributes)
      @code = attributes["code"]
      super("#{attributes["message"]} (#{@code})")
    end

    attr_reader :code
  end
end
