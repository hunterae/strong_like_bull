require 'rubygems'
require 'bundler/setup'
require 'byebug'
require 'strong_like_bull'

RSpec.configure do |config|
  config.mock_with :mocha
end

