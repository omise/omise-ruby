require "omise/list"

module Omise
  class DocumentList < List
    def retrieve(id, attributes = {})
      if !defined?(Document)
        require "omise/document"
      end

      Document.new self.class.resource(location(id), attributes).get(attributes)
    end

    def upload(file)
      if !defined?(Document)
        require "omise/document"
      end

      attributes = { file: file }
      Document.new self.class.resource(location, attributes).post(attributes)
    end
  end
end
