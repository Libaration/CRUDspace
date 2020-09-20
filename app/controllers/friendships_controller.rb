class FriendshipsController < ApplicationController

  get '/user/:id/add' do
    if current_user == User.find(params[:id])
      "You can't add yourself..."
    elsif current_user != User.find(params[:id]) && logged_in? && !current_user.friends.include?(User.find(params[:id]))
      @newfriend = User.find(params[:id])
      current_user.friends << @newfriend
      @newfriend.friends << current_user
      redirect "/user/#{@newfriend.id}"
    end
  end

end
