require './config/environment'
require "carrierwave"
require "carrierwave/orm/activerecord"
#Configure Carrierwave

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'app/public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"

  end


  get "/" do
    erb :index
  end

end
