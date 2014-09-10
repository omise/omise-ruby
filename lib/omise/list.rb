require "omise/resource"

module Omise
  class List < Resource
    include Enumerable

    def initialize(attributes = {})
      super
      @data = attributes["data"].map { |o| Omise::Resource.typecast(o) }
    end

    def find(id)
      Omise.resource([location, id].join("/")).get do |response|
        self.class.typecast JSON.load(response)
      end
    end

    def create(attributes = {})
      Omise.resource(location).post(attributes) do |response|
        self.class.typecast JSON.load(response)
      end
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
