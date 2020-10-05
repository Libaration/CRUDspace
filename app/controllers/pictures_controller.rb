class PicturesController < ApplicationController
  get '/users/:id/pictures' do
    @user = User.find_by_slug(params[:id])
      erb :'/users/pictures/picture', :layout => :template
  end

  get '/users/:id/picture/edit' do
    if logged_in? && User.find_by_slug(params[:id]) == current_user
      @user = current_user
      erb :'/users/picture', :layout => :template
    else
      'either not logged in or current users'
    end
  end

  get '/users/:id/pictures/:picture_id' do
    @user = User.find_by_slug(params[:id])
    @image = Images.find(params[:picture_id])
    erb :'users/pictures/show', :layout => :template
  end

  delete '/users/:id/pictures/:picture_id' do
    @user = User.find_by_slug(params[:id])
    @image = Images.find(params[:picture_id])
    if logged_in? && @user == current_user
      @image.destroy
      redirect "/users/#{@user.id}/pictures"
    else
      'You do not have permission to perform this action'
    end
  end

  post '/users/:id/pictures' do
    if logged_in? && current_user == User.find_by_slug(params[:id])
      img = Images.new
      img.image  = params[:file] #carrierwave uploads using params here
      img.user = current_user
      img.caption = params[:caption]
      img.save!
      redirect "/users/#{current_user.id}/pictures/#{img.id}"
    else
      'You do not have permission to perform this action'
    end
  end

  patch '/users/:id/pictures/:picture_id' do
    if logged_in? && current_user == User.find_by_slug(params[:id])
    img = Images.find(params[:picture_id])
    img.update(caption: params[:caption])
    redirect "/users/#{current_user.id}/pictures"
    end
  end


end
