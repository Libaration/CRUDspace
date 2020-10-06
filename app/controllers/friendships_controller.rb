class FriendshipsController < ApplicationController
  before('/users/:id/add') do
    require_login
  end
  before('/users/:id/approve') do
    require_login
    user_can_edit?(params[:id])
  end
  before('/users/:id/deny') do
    require_login
    user_can_edit?(params[:id])
  end
  before('/users/:id/remove') do
    require_login
  end
  before('/users/:id/friend_requests') do
    require_login
    user_can_edit?(params[:id])
  end

  get '/users/:id/add' do
    if current_user == User.find_by_slug(params[:id])
      "You can't add yourself..."
    elsif current_user != User.find_by_slug(params[:id]) && !current_user.friends.include?(User.find_by_slug(params[:id]))
      @newfriend = User.find_by_slug(params[:id])
      @newfriend.pending_friends << current_user unless @newfriend.pending_friends.include?(current_user)
      redirect "/users/#{@newfriend.id_or_slug}"
    end
  end

  post '/users/:id/approve' do
    @user = User.find_by_slug(params[:id])
    @friend = User.find_by_slug(params[:friend_id])
    if current_user.pending_friends.include?(@friend)
      @user.pending_friends.delete(@friend)
      @user.friends << @friend
      @friend.friends << @user
    else
      'An error has occurred'
    end
    redirect "/users/#{current_user.id_or_slug}/friend_requests"
  end

  delete '/users/:id/deny' do
    @user = User.find_by_slug(params[:id])
    @friend = User.find_by_slug(params[:friend_id])
    if current_user.pending_friends.include?(@friend)
      @user.pending_friends.delete(@friend)
    else
      'An error has occurred'
    end
    redirect "/users/#{current_user.id_or_slug}/friend_requests"
  end

  get '/users/:id/remove' do
    if current_user == User.find_by_slug(params[:id])
      "You can't add yourself..."
    elsif current_user != User.find_by_slug(params[:id]) && current_user.friends.include?(User.find_by_slug(params[:id]))
      @friend = User.find_by_slug(params[:id])
      current_user.friends.destroy(@friend)
      @friend.friends.destroy(current_user)
      redirect "/users/#{@friend.id_or_slug}"
    end
  end

  get '/users/:id/friend_requests' do
    @user = User.find_by_slug(params[:id])
    erb :'/users/friend_requests', layout: :template
  end

end
