class FriendshipsController < ApplicationController

  get '/user/:id/add' do
    redirect '/login' if !logged_in?
    if current_user == User.find(params[:id])
      "You can't add yourself..."
    elsif current_user != User.find(params[:id]) && logged_in? && !current_user.friends.include?(User.find(params[:id]))
      @newfriend = User.find(params[:id])
      @newfriend.pending_friends << current_user unless @newfriend.pending_friends.include?(current_user)
      redirect "/user/#{@newfriend.id}"
    end
  end

  post '/user/:id/approve' do
    @user = User.find(params[:id])
    @friend = User.find(params[:friend_id])
    if logged_in? && current_user == @user && current_user.pending_friends.include?(@friend)
      @user.pending_friends.delete(@friend)
      @user.friends << @friend
      @friend.friends << @user
    else
      'An error has occurred'
    end
    redirect "/user/#{current_user.id}/friend_requests"
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
