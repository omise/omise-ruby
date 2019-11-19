require "omise/object"

module Omise
  # A {Document} allows you to upload and store files related, at this time, to
  # disputes.
  #
  # See https://www.omise.co/documents-api for more information regarding
  # the document attributes, the available endpoints and the different
  # parameters each endpoint accepts.
  #
  class Document < OmiseObject
    self.endpoint = "/documents"

    # Reloads an existing document.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/disputes/DISPUTE_ID/documents/DOCUMENT_ID
    #
    # Example:
    #
    #     dispute  = Omise::Dispute.retrieve(dispute_id)
    #     document = dispute.documents.first
    #     document.reload
    #
    # Returns the same {Document} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(params = {})
      assign_attributes client.get(location, params: params, as: Hash)
    end

    # Destroys an existing document.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - DELETE https://api.omise.co/disputes/DISPUTE_ID/documents/DOCUMENT_ID
    #
    # Example:
    #
    #     dispute  = Omise::Dispute.retrieve(dispute_id)
    #     document = dispute.documents.first
    #     document.destroy
    #     document.destroyed?
    #
    # Returns the same {Document} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def destroy
      assign_attributes client.delete(location, as: Hash)
    end
  end
end
