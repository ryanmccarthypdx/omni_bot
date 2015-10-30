require 'bundler/setup'
require 'tilt/erb'

Bundler.require :default
Dotenv.load

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

enable :sessions
set :session_secret, ENV['SESSION_SECRET']

helpers do
  def logged_in?
    session[:id]
  end
end

get '/' do
  # @user
  # @phone_error

  erb :no_session
end

post '/login' do
  redirect '/home'
end

post '/register' do
  if logged_in?
    redirect '/'
  end
  @user = User.new(
    phone: params[:phone],
    location: params[:location],
    password: params[:password],
    password_confirmation: params[:password_confirmation])
  if @user.save
    session[:id] = @user.id
    redirect '/confirm_phone'
  else
    flash[:error_type] = @user.errors.messages.keys.first
    flash[:create_error] = @user.errors.full_messages.to_sentence
    redirect '/'
  end
end
