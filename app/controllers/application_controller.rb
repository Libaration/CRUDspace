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
        redirect "/users/#{current_user.id_or_slug}"
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

    def require_login
      if !logged_in?
        redirect '/login'
      end
    end

    def user_can_edit?(id)
      redirect '/login' unless current_user == User.find_by_slug(id)
    end

    def set_last_seen_at
      current_user.touch(:last_seen_at)
    end

    end
end
