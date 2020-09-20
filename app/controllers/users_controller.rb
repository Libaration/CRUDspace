require './app/controllers/images_uploader'

class UsersController < ApplicationController

  get '/user/new' do
    erb :'/user/new' , :layout => :template
  end

  get '/user/:id' do
    if logged_in?
      @user = User.find(params[:id])
      @profilepic = @user.images.first
      erb :'user/show'
    end
  end

  post '/user' do
    binding.pry
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
