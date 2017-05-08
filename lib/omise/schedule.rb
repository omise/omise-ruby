require "omise/object"
require "omise/list"
require "omise/occurrence_list"

module Omise
  class Schedule < OmiseObject
    self.endpoint = "/schedules"

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
    end

    def self.retrieve(id, attributes = {})
      new resource(location(id), attributes).get(attributes)
    end

    def self.create(attributes = {})
      new resource(location, attributes).post(attributes)
    end

    def occurrences
      list_attribute OccurrenceList, "occurrences"
    end

    def destroy(attributes = {})
      assign_attributes resource(attributes).delete
    end
  end
end
