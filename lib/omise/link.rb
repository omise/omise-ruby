require "omise/object"
require "omise/list"
require "omise/charge_list"
require "omise/search_scope"

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

    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end

    def charges(options = {})
      if options.empty?
        list_attribute ChargeList, "charges"
      else
        response = collection.resource(location("charges")).get(options)
        ChargeList.new(self, response)
      end
    end
  end
end
