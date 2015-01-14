require "omise/object"

module Omise
  class List < OmiseObject
    include Enumerable

    def initialize(attributes = {})
      super(attributes)
      setup_data
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get do
        setup_data
      end
    end

    def each(*args, &block)
      to_a.each(*args, &block)
    end

    def to_a
      @data
    end

    def last
      to_a.last
    end

    private

    def setup_data
      @data = @attributes["data"].map { |o| Omise.typecast(o) }
    end
  end
end
