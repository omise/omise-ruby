require "omise/object"
require "omise/charge"
require "omise/list"

module Omise
  class Dispute < OmiseObject
    self.endpoint = "/disputes"

    def self.list(attributes = {})
      List.new resource(location, attributes).get
    end

    def self.open(attributes = {})
      List.new resource(location("open"), attributes).get
    end

    def self.pending(attributes = {})
      List.new resource(location("pending"), attributes).get
    end

    def self.closed(attributes = {})
      List.new resource(location("closed"), attributes).get
    end

    def self.retrieve(id = nil, attributes = {})
      new resource(location(id), attributes).get
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get
    end

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    def charge(options = {})
      if @attributes["charge"]
        @charge ||= Charge.retrieve(@attributes["charge"], options)
      end
    end

    private

    def cleanup!
      @charge = nil
    end
  end
end
