class PicturesController < ApplicationController
  get '/user/:id/pictures' do
    if logged_in?
      @user = current_user
      erb :'/user/picture', :layout => :template
    else
      'not logged in'
    end
  end
end
