require "omise/version"
require "omise/configurator"

module Omise
  LIB_PATH = File.expand_path("../", __FILE__)
  OBJECTS = [
    "account",
    "balance",
    "bank_account",
    "capability",
    "card",
    "chain",
    "charge",
    "customer",
    "dispute",
    "document",
    "event",
    "forex",
    "integration",
    "link",
    "occurrence",
    "recipient",
    "refund",
    "schedule",
    "search",
    "source",
    "token",
    "transaction",
    "transfer",
  ]

  extend Configurator

  self.api_url   = "https://api.omise.co"
  self.vault_url = "https://vault.omise.co"

  OBJECTS.each do |object|
    require "omise/#{object}"
  end
end
