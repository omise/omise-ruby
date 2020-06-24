module Omise
  # {Error} is the top level exception and is raised whenever an API calls
  # fails to succeed and a error object is returned.
  #
  # Visit https://www.omise.co/api-errors to learn more about all the
  # possible errors.
  #
  # @todo Subclass into APIError and ClientError. Which in turn should probably
  #   be subclassed into different kind of exceptions for different scenarios.
  #
  class Error < StandardError
    def initialize(attributes)
      @code = attributes["code"]
      super("#{attributes["message"]} (#{@code})")
    end

    # The error code returned by the API
    #
    attr_reader :code
  end
end
