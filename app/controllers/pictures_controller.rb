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
end
