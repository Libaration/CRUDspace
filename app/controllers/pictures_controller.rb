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

  post '/user/:id/pictures' do
    img = Images.new
    img.image  = params[:file] #carrierwave uploads using params here
    img.user = current_user
    img.save!
    redirect "/user/#{current_user.id}/pictures/#{img.id}"
  end
end
