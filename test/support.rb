require "rubygems"
require "bundler/setup"

Bundler.require(:default, :test)

require "yaml"
config_file = File.expand_path(File.join("..", "config.yml"), __FILE__)
config = YAML.load_file(config_file)

if !config["api_url"] || !config["api_key"] || !config["vault_url"] || !config["vault_key"]
  puts
  puts "You need to configure the test environment in test/config.yml"
  puts
  puts("-" * 72)
  puts
  raise
end

Omise.api_url = config["api_url"]
Omise.api_key = config["api_key"]
Omise.vault_url = config["vault_url"]
Omise.vault_key = config["vault_key"]

require "minitest/autorun"
