require './app/controllers/images_uploader'

class UsersController < ApplicationController
  get '/users/new' do
    if !logged_in?
      erb :'users/new' , :layout => :template
    else
      redirect "users/#{current_user.id}"
    end
  end

  get '/users/:id/url/edit' do
    @user = User.find_by(params)
    @error = ""
    if logged_in? && @user == current_user && @user.url.nil?
      erb :'users/url/edit' , :layout => :template
    else
      "You have already set a custom URL"
    end
  end

  patch '/users/:id/url' do
    @user = User.find(params[:id])
    if logged_in? && @user == current_user && @user.url.nil?
      if  params[:url] == params[:urlconfirm] && User.find_by(url: params[:url]).nil? && params[:url].match?(/\A[a-zA-Z'-]*\z/)
        @user.url = params[:url].downcase
        @user.save
        redirect "/#{@user.url}"
      elsif params[:url] != params[:urlconfirm] || !User.find_by(url: params[:url]).nil? || !params[:url].match?(/\A[a-zA-Z'-]*\z/)
        @error = "Fields do not match, URL taken, or URL contains invalid characters/spaces"
        erb :'users/url/edit' , :layout => :template
      end
    end
  end

  get '/users/:id' do
      User.find_by_slug(params[:id]).nil? ? @user = User.find(params[:id]) : @user = User.find_by_slug(params[:id])
      @profilepic = @user.images.first
      @comments = @user.comments.reverse
      erb :'users/show', :cache => false
  end

  post '/users' do
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
      if !params[:username].empty? && User.find_by(username: params[:username]).nil? && params[:file][:type].include?("image")
        @user = User.create(params.except(:file, :x, :y))
        tomswelcome(@user)
        img = Images.new
        img.image  = params[:file] #carrierwave uploads using params here
        img.user = @user
        img.save!
        session[:user_id] = @user.id
        redirect to("users/#{@user.id}")
      end
    end
    erb :'users/new', :layout => :template
  end

  get '/login' do
    @users = User.order(id: :desc).limit(2)
    redirect "users/#{current_user.id}" if logged_in?
    erb :'users/login' , :layout => :template
  end

  post'/login' do
    @users = User.order(id: :desc).limit(2)
    if (@user = User.find_by(username: params[:username])) && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      if @user.url.nil?
        redirect "users/#{@user.id}"
      elsif !@user.url.nil?
        redirect "users/#{@user.url}"
      end
    else
      @error = 'One of the fields was incorrect'
      erb :'users/login', :layout => :template

    end

  end

  get '/users/:id/edit' do
    User.find_by_slug(params[:id]).nil? ? @user = User.find(params[:id]) : @user = User.find_by_slug(params[:id])
    if Pathname("./app/public/profile_css/#{@user.id}_custom_css.css").exist?
      @custom_css = File.read("./app/public/profile_css/#{@user.id}_custom_css.css")
    end
    if logged_in? && @user == current_user
      erb :'users/edit', layout: :template
    else
      'You do not have permission to view this page'
    end
  end

  post '/users/:id/edit' do
    @user = User.find(params[:id])
    if logged_in? && @user == current_user
      # params.each do |key,value|
      #   params[key.to_sym] = Sanitize.fragment(value, Sanitize::Config::RELAXED)
      # end
      @user.update(params.except(:css))
      path = "./app/public/profile_css/#{@user.id}_custom_css.css"
      content = Sanitize::CSS.stylesheet(params[:css], Sanitize::Config::RELAXED).gsub(".module", ".topRight, .topLeft").gsub("div.contentTop", "div.extended").gsub(".blurbsModule", ".rightHead").gsub(".content",".boxHead").gsub("div.wrap",".tableLeft, .tableRight")
      content += ".topRight{
        float: right;
        width: calc( 60% - 20px );
        padding: 0px
      }

      .topLeft{
        float: left;
        width: calc( 40% - 20px );
        padding:0px;
      }" unless content.blank?
      File.open(path, "w+") do |f|
        f.write(content)
      end

      if @user.url.nil?
        redirect "/users/#{@user.id}"
      elsif !@user.url.nil?
        redirect "/users/#{@user.url}"
      end
    else
      'You do not have permission to view this page'
    end
  end

  get '/logout' do
    session.clear if logged_in?
    redirect '/login'
  end

  get '/users' do
    @users = User.all
    erb :'users/all_users', :layout => :template
  end

  helpers do
    def tomswelcome(user)
      @tom = User.find(1)
      user.friends << @tom
      @tom.friends << @user
      @message = Message.create(subject: "Welcome!", content: "Welcome to CRUDSpace! Message me if you run into any issues!", sender: @tom)
      @message.update(receiver: user)
    end
  end

end
