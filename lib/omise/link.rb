require "omise/object"
require "omise/charge_list"

module Omise
  class Link < OmiseObject
    self.endpoint = "/links"

    def self.search
      SearchScope.new(:link)
    end

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
    end

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def charges
      list_attribute ChargeList, "charges"
    end
  end
end
