require './config/environment'
require "carrierwave"
require "carrierwave/orm/activerecord"
require 'sanitize'
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
      if current_user.url.nil?
        redirect "/users/#{current_user.id}"
      elsif !current_user.url.nil?
        redirect "/users/#{current_user.url}"
      end
    else
      redirect "/login"
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
