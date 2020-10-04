class SongsController < ApplicationController
  get '/users/:id/profile_song/new' do
    if logged_in? && (@user = User.find_by_slug(params[:id]) || User.find(params[:id])) && current_user == @user
      erb :'/users/profile_song/new', :layout => :template
    end
  end
end
