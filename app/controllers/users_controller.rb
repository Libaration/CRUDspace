require './app/controllers/images_uploader'

class UsersController < ApplicationController

  get '/user/new' do
    erb :'/user/new' , :layout => :template
  end

  get '/user/:id' do
    #binding.pry
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
      @tom = User.find(3)
      @user.friends << @tom
      @tom.friends << @user
      img = Images.new
      img.image  = params[:file] #carrierwave uploads using params here
      img.user = @user
      img.save!
      session[:user_id] = @user.id
    end

    redirect to("/user/#{@user.id}")
  end

end
