require 'bundler/setup'
require 'tilt/erb'
Bundler.require :default
Dotenv.load

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get '/' do
  erb :no_session
end

post '/login' do
  redirect '/home'
end

post '/register' do
  redirect '/home'
end
