module Omise
  module Vault
    private

    def resource_url
      Omise.vault_url
    end

    def resource_key
      Omise.public_api_key
    end
  end
end
