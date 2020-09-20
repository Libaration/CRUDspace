require './app/controllers/images_uploader'

class UsersController < ApplicationController

  get '/user/new' do
    erb :'/user/new' , :layout => :template
  end

  get '/user/:id' do
    #binding.pry
      @user = User.find(params[:id])
      @profilepic = @user.images.first
      erb :'user/show'
  end

  post '/user' do
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

  get '/login' do
    redirect "/user/#{current_user.id}" if logged_in?
    erb :'/user/login'
  end

  get '/logout' do
    session.clear if logged_in?
    redirect '/login'
  end

end
