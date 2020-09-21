class FriendshipsController < ApplicationController

  get '/user/:id/add' do
    redirect '/login' if !logged_in?
    if current_user == User.find(params[:id])
      "You can't add yourself..."
    elsif current_user != User.find(params[:id]) && logged_in? && !current_user.friends.include?(User.find(params[:id]))
      @newfriend = User.find(params[:id])
      current_user.pending_friends << @newfriend
      @newfriend.pending_friends << current_user
      redirect "/user/#{@newfriend.id}"
    end
  end


  get '/user/:id/remove' do
    redirect '/login' if !logged_in?
    if current_user == User.find(params[:id])
      "You can't add yourself..."
    elsif current_user != User.find(params[:id]) && logged_in? && current_user.friends.include?(User.find(params[:id]))
      @friend = User.find(params[:id])
      current_user.friends.destroy(@friend)
      @friend.friends.destroy(current_user)
      redirect "/user/#{@friend.id}"
    end
  end

  get '/user/:id/friend_requests' do
    @user = User.find(params[:id])
    erb :'/user/friend_requests', layout: :template
  end

end
