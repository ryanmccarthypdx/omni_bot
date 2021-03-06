require 'bundler/setup'
require 'tilt/erb'

Bundler.require :default
Dotenv.load

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

enable :sessions

CODE_VALID_TIME = 10 #minutes
MAX_CONFIRMATIONS = 5

helpers do
  def logged_in?
    session[:id]
  end

  def current_user
    @current_user = User.find(session[:id])
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
  user = User.new(
    phone: params[:create_phone],
    location: params[:location],
    password: params[:create_password],
    password_confirmation: params[:password_confirmation])
  if user.save
    session[:id] = user.id
    redirect '/confirm_phone'
  else
    flash[:error_type] = user.errors.messages.keys.first
    flash[:create_error] = user.errors.full_messages.to_sentence
    redirect '/'
  end
end

get '/confirm_phone' do
  erb :confirm_phone
end

post '/confirm_phone' do
  begin
    current_user.confirm_phone(params[:phone_confirm])
    redirect '/services'
  rescue => e
    flash[:confirm_error] = e.message
    redirect '/confirm_phone'
  end
end

post '/resend_confirmation' do
  begin
    current_user.send_out_new_code
  rescue => e
    flash[:confirm_error] = e.message
  end
  redirect '/confirm_phone'
end

get '/services' do

  erb :services
end
