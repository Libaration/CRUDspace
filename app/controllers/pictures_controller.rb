class PicturesController < ApplicationController
  get '/user/:id/pictures' do
    @user = User.find(params[:id])
      erb :'/user/pictures/picture', :layout => :template
  end

  get '/user/:id/pictures/:picture_id' do
    @user = User.find(params[:id])
    @image = Images.find(params[:picture_id])
    erb :'user/pictures/show', :layout => :template
  end

  delete '/user/:id/pictures/:picture_id' do
    @user = User.find(params[:id])
    @image = Images.find(params[:picture_id])
    if logged_in? && @user == current_user
      @image.destroy
      redirect "/user/#{@user.id}/pictures"
    else
      'You do not have permission to perform this action'
    end
  end

  post '/user/:id/pictures' do
    if logged_in? && current_user == User.find(params[:id])
      img = Images.new
      img.image  = params[:file] #carrierwave uploads using params here
      img.user = current_user
      img.caption = params[:caption]
      img.save!
      redirect "/user/#{current_user.id}/pictures/#{img.id}"
    else
      'You do not have permission to perform this action'
    end
  end

  patch '/user/:id/pictures/:picture_id' do
    if logged_in? && current_user == User.find(params[:id])
    img = Images.find(params[:picture_id])
    img.update(caption: params[:caption])
    redirect "/user/#{current_user.id}/pictures"
    end
  end
end
