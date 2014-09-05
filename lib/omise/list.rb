require "omise/thing"

module Omise
  class List < Thing
    include Enumerable

    def initialize(attributes = {})
      super
      @data = attributes["data"].map { |o| Omise::Thing.typecast(o) }
    end

    def create(attributes = {})
      Omise::Resource.new(location).create(attributes)
    end

    def each(*args, &block)
      to_a.each(*args, &block)
    end

    def destroy_all
      each(&:destroy)
    end

    def to_a
      @data
    end
  end
end
