class SongsController < ApplicationController
  get '/users/:id/profile_song/new' do
    if logged_in? && (@user = User.find_by_slug(params[:id]) || User.find(params[:id])) && current_user == @user
      erb :'/users/profile_song/new', :layout => :template
    end
  end

  post '/users/:id/profile_song' do
    if logged_in? && (@user = User.find_by_slug(params[:id]) || User.find(params[:id])) && current_user == @user && params[:file][:type].include?("mpeg")
        @user.song.destroy if !@user.song.nil?
        song = Song.new
        song.profilesong  = params[:file] #carrierwave uploads using params here
        song.user = @user
        song.save!
        redirect "/users/#{@user.url.nil? ? @user.id : @user.url}"
    else
      @error = "Invalid permissions/Invalid filetype"
      erb :'/users/profile_song/new', :layout => :template
    end
  end
end
