module Omise
  module SingletonResource
    def self.included(base)
      base.extend ClassMethods
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get
    end

    def location
      self.class.location
    end

    module ClassMethods
      def retrieve(attributes = {})
        new resource(location, attributes).get
      end
    end
  end
end
