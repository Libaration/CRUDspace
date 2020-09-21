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
    if logged_in?
      redirect "/user/#{current_user.id}"
    else
      redirect "/signup"
    end
    erb :index
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end
end
