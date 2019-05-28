require "omise/object"
require "omise/list"
require "omise/document_list"
require "omise/search_scope"

module Omise
  class Dispute < OmiseObject
    self.endpoint = "/disputes"

    def self.search
      SearchScope.new(:dispute)
    end

    def self.list(attributes = {})
      status = attributes.delete(:status)
      List.new resource(location(status), attributes).get(attributes), options
    end

    def self.retrieve(id = nil, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    def update(attributes = {})
      assign_attributes resource(attributes).patch(attributes)
    end

    def charge(options = {})
      if !defined?(Charge)
        require "omise/charge"
      end

      expand_attribute Charge, "charge", options
    end

    def documents(options = {})
      list_nested_resource DocumentList, "documents", options
    end
  end
end
