require "omise/list"
require "omise/occurrence"

module Omise
  class OccurrenceList < List
    def retrieve(id, attributes = {})
      Occurrence.retrieve(id, attributes)
    end
  end
end
