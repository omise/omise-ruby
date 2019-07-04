require "omise/config"
require "omise/account"
require "omise/balance"
require "omise/bank_account"
require "omise/card"
require "omise/chain"
require "omise/charge"
require "omise/customer"
require "omise/dispute"
require "omise/document"
require "omise/event"
require "omise/forex"
require "omise/link"
require "omise/occurrence"
require "omise/recipient"
require "omise/refund"
require "omise/search"
require "omise/source"
require "omise/schedule"
require "omise/token"
require "omise/transaction"
require "omise/transfer"
require "omise/version"

module Omise
  LIB_PATH = File.expand_path("../", __FILE__)

  extend Config

  self.api_url   = "https://api.omise.co"
  self.vault_url = "https://vault.omise.co"
end
