# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strong_like_bull/version'

Gem::Specification.new do |spec|
  spec.name          = "strong_like_bull"
  spec.version       = StrongLikeBull::VERSION
  spec.authors       = ["Andrew Hunter"]
  spec.email         = ["andrew.hunter@livingsocial.com"]
  spec.summary       = %q{Upgrade to strong parameters the easy way}
  spec.description   = %q{Makes it super simple to add strong parameters into your application by examining request parameters and recommending what feeds should be permitted.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 3.0.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "byebug"
end
