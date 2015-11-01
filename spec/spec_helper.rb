ENV['RACK_ENV'] = 'test'
require './app'

require 'bundler/setup'
Bundler.require :default, :test

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL

  config.after(:each) do
    User.all.each { |u| u.destroy }
    Subscription.all.each { |s| s.destroy }
    # Service.each { |s| s.destroy }
  end
end

FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryGirl.find_definitions
