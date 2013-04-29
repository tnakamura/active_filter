# coding: utf-8
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bundler/setup'
Bundler.require

begin
  require 'rails'
  require 'active_record'
rescue LoadError
end

#require 'capybara/rspec'
require 'database_cleaner'

# Simulate a gem providing a subclass of ActiveRecord::Base before the Railtie is loaded.
require 'fake_gem' if defined? ActiveRecord

require "active_filter"


if defined? Rails
  require 'fake_app/rails_app'
  require 'rspec/rails'
end
#if defined? Sinatra
  #require 'spec_helper_for_sinatra'
#end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# Requires fixtures
require 'factory_girl'
Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each {|f| require f}

require "coveralls"
Coveralls.wear!

RSpec.configure do |config|
  #config.mock_with :rr
end

