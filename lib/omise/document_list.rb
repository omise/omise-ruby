require "omise/list"

module Omise
  # {DocumentList} represents a list of documents. It inherits from {List} and
  # as such can be paginated. This class exposes two additional methods to help
  # you retrieve and upload documents.
  #
  # Example:
  #
  #     dispute   = Omise::Dispute.retrieve(dispute_id)
  #     documents = dispute.documents
  #
  # See https://www.omise.co/documents-api for more information regarding the
  # document attributes, the available endpoints and the different parameters
  # each endpoint accepts. And you can find out more about pagination and list
  # options by visiting https://www.omise.co/api-pagination.
  #
  class DocumentList < List
    # Retrieves a document object that belongs to the parent dispute object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/disputes/DISPUTE_ID/documents/DOCUMENT_ID
    #
    # Example:
    #
    #     dispute   = Omise::Dispute.retrieve(dispute_id)
    #     documents = dispute.documents
    #     documents.retrieve(document_id)
    #
    # Returns a new {Document} instance if successful and raises an {Error} if
    # the request fails.
    #
    def retrieve(id, attributes = {})
      if !defined?(Document)
        require "omise/document"
      end

      Document.new self.class.resource(location(id), attributes).get(attributes)
    end

    # Upload a document object and attach it to the parent dispute object.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - POST https://api.omise.co/disputes/DISPUTE_ID/documents
    #
    # Example:
    #
    #     dispute   = Omise::Dispute.retrieve(dispute_id)
    #     documents = dispute.documents
    #     documents.upload(file)
    #
    # Returns a new {Document} instance if successful and raises an {Error} if
    # the request fails.
    #
    def upload(file)
      if !defined?(Document)
        require "omise/document"
      end

      attributes = { file: file }
      Document.new self.class.resource(location, attributes).post(attributes)
    end
  end
end
