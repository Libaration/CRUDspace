require './app/controllers/images_uploader'

class UsersController < ApplicationController

  get '/user/new' do
    @avatar = Images.last
    erb :'/user/new' , :layout => :template
  end

  get '/user/:id' do
    if logged_in?
      @user = current_user
      @profilepic = Images.find_by(user: @user)
      erb :'user/show'
    end
  end

  post '/user' do
    if !params[:username].empty? && User.find_by(username: params[:username]).nil?
      @user = User.create(params.except(:file))
      img = Images.new
      img.image  = params[:file] #carrierwave uploads using params here
      img.user = @user
      img.save!
      session[:user_id] = @user.id
    end

    redirect to("/user/#{@user.id}")
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
