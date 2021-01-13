require 'rubygems'
require 'bundler/setup'
require 'byebug'
require 'strong_like_bull'

RSpec::Matchers.define :match_hash do |expected|
  match { |actual| expect(actual.to_unsafe_h).to match(expected) }
end

RSpec.configure do |config|
  config.mock_with :rspec
end

