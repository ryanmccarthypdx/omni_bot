ENV['RACK_ENV'] = 'test'
require './app'

require 'bundler/setup'
require 'rack_session_access/capybara'

Bundler.require :default, :test

Capybara.app = Sinatra::Application

Capybara.app.configure do |app|
  app.use RackSessionAccess::Middleware
end

RSpec.configure do |config|
  config.include Capybara::DSL

  config.after(:each) do
    Capybara.current_session.driver.browser.clear_cookies

    User.all.each { |u| u.destroy }
    Subscription.all.each { |s| s.destroy }
    # Message.all.each { |m| m.destroy }
    # Service.each { |s| s.destroy }
  end
end

FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryGirl.find_definitions
