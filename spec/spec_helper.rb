$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'intervals'
require 'pry'
require 'pry-nav'
RSpec.configure do |config|
  config.before(:each) do
    Redis.new.flushdb
  end
end
