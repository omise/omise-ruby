require "omise/document"
require "omise/list"

module Omise
  class DocumentList < List
    def retrieve(id, attributes = {})
      Document.new self.class.resource(location(id), attributes).get(attributes)
    end

    def upload(file)
      attributes = { file: file }
      Document.new self.class.resource(location, attributes).post(attributes)
    end
  end
end
