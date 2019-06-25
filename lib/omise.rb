require "omise/config"
require "omise/all"
require "omise/version"

module Omise
  LIB_PATH = File.expand_path("../", __FILE__)

  extend Config

  self.api_url   = "https://api.omise.co"
  self.vault_url = "https://vault.omise.co"
end
