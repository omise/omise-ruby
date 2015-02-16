# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omise/version'

Gem::Specification.new do |spec|
  spec.name          = "omise"
  spec.version       = Omise::VERSION
  spec.authors       = ["Robin Clart"]
  spec.email         = ["robin@omise.co"]
  spec.summary       = %q{Omise Ruby client}
  spec.homepage      = "https://www.omise.co/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 1.7.2"
  spec.add_dependency "json", "~> 1.8.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.4.2"
end
