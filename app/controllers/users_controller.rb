require './app/controllers/images_uploader'

class UsersController < ApplicationController

  get '/user/new' do
    if !logged_in?
      erb :'/user/new' , :layout => :template
    else
      redirect "/user/#{current_user.id}"
    end
  end

  get '/user/:id' do
    #binding.pry
      @user = User.find(params[:id])
      @profilepic = @user.images.first
      erb :'user/show'
  end

  post '/user' do
    params.except(:bio, :motto).values.each do |value|
      if value.blank?
        @error = 'All values except bio and motto are required'
      end
    end
    if params[:file].nil?
      @error = 'Profile picture is required!'
    elsif !User.find_by(username: params[:username]).nil?
      @error = 'Username already exists'
    else
      if !params[:username].empty? && User.find_by(username: params[:username]).nil?
        @user = User.create(params.except(:file))
        @tom = User.find(1)
        @user.friends << @tom
        @tom.friends << @user
        img = Images.new
        img.image  = params[:file] #carrierwave uploads using params here
        img.user = @user
        img.save!
        session[:user_id] = @user.id
        redirect to("/user/#{@user.id}")
      end
    end
    erb :'/user/new', :layout => :template
  end

  get '/login' do
    redirect "/user/#{current_user.id}" if logged_in?
    erb :'/user/login' , :layout => :template
  end

  post'/login' do
    if (@user = User.find_by(username: params[:username])) && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/user/#{@user.id}"
    else
      @error = 'One of the fields was incorrect'
      erb :'/user/login', :layout => :template

    end

  end

  get '/user/:id/edit' do
    @user = User.find(params[:id])
    if logged_in? && @user == current_user
      erb :'/user/edit', layout: :template
    else
      'You do not have permission to view this page'
    end
  end

  post '/user/:id/edit' do
    @user = User.find(params[:id])
    if logged_in? && @user == current_user
      @user.update(params)
      redirect "/user/#{@user.id}"
    else
      'You do not have permission to view this page'
    end
  end

  get '/logout' do
    session.clear if logged_in?
    redirect '/login'
  end

  get '/friends' do
    @users = User.all
    erb :'/user/all_users', :layout => :template
  end


end
