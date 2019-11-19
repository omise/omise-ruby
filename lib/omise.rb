require "omise/version"
require "omise/config"

module Omise
  LIB_PATH = File.expand_path("../", __FILE__)

  extend Config

  self.api_url   = "https://api.omise.co"
  self.vault_url = "https://vault.omise.co"

  OBJECTS = %w[account balance bank_account capability card chain charge
    customer dispute document event forex link integration occurrence recipient
    refund search source schedule token transaction transfer]

  OBJECTS.each do |object|
    require "omise/#{object}"
  end
end
