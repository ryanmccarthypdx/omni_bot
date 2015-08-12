ENV['RACK_ENV'] = 'test'
require './app'

require 'bundler/setup'
Bundler.require :default, :test

Capybara.app = Sinatra::Application
