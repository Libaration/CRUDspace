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
      redirect "/users/#{current_user.id}"
    else
      redirect "/login"
    end
    erb :index
  end

  get '/:url' do
    @user = User.find_by(url: params[:url].downcase)
    if @user != nil
      @profilepic = @user.images.first
      @comments = @user.comments.reverse
      erb :'users/show', :cache => false
    else
      'Profile not found'
    end
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
