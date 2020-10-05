class MessagesController < ApplicationController
  before('/users/:id/messages/*') do
    require_login
  end
  post'/users/:id/messages' do
    @user = User.find(params[:id])
    @message = Message.find(params[:msg_id])
    if logged_in? && @user == current_user && @message.receiver == current_user
      params[:content].gsub!(/\r\n/, '<br />')
      Message.create(params.except(:msg_id, :id)).tap do |new_message|
        new_message.sender = @user
        new_message.receiver = @message.sender
        new_message.save
      end
      @message.update(replied: true)
      redirect "/users/#{@user.id}/messages"
    else
      redirect '/login'
    end
  end

  get'/users/:id/messages/:msg_id/reply' do
    @user = User.find(params[:id])
    @message = Message.find(params[:msg_id])
    if logged_in? && @user == current_user && @message.receiver == current_user
      erb :'users/messages/reply', layout: :template
    else
      redirect '/login'
    end
  end

  get'/users/:id/messages/:friend_id/new' do
    @user = User.find(params[:id])
    @friend = User.find(params[:friend_id])
    if logged_in? && @user == current_user
      erb :'users/messages/new', layout: :template
    else
      redirect '/login'
    end
  end

  get '/users/:id/messages/:message_id' do
    @user = User.find(params[:id])
    @message = Message.find(params[:message_id])
    @messages = @user.messages
    if logged_in? && @user == current_user && @message.receiver == current_user
      @message.update(read: true)
      # @message = User.find(params[:id]).messages.where(id: params[:message_id]).first
      erb :'/users/messages/show', layout: :template
    else
      redirect '/login'
    end
  end

  post '/users/:id/messages/:friend_id' do
    @user = User.find(params[:id])
    @friend= User.find(params[:friend_id])
    if logged_in? && @user == current_user
      params[:content].gsub!(/\r\n/, '<br />')
      Message.create(params.except(:friend_id, :id)).tap do |new_message|
        new_message.sender = @user
        new_message.receiver = @friend
        new_message.save
      end
      redirect "/users/#{@user.id}/messages"
    else
      redirect '/login'
    end
  end

  get '/users/:id/messages' do
    @user = User.find(params[:id])
    if params[:start].nil? && params[:end].nil?
      params[:start] = 0
      params[:end] = 5
    end
    @messages = @user.messages.reverse[params[:start].to_i...params[:end].to_i]
    if logged_in? && @user == current_user
      erb :'/users/messages/home', layout: :template
    end
  end

  patch'/users/:id/messages' do
    @user = User.find(params[:id])
    if logged_in? && @user == current_user
      @user.messages.where(params[:message_id]).update_all(read: true)
      redirect "/users/#{@user.id}/messages"
    else
      redirect '/login'
    end
  end

  delete'/users/:id/messages' do
    @user = User.find(params[:id])
    if logged_in? && @user == current_user
      @user.messages.where(params[:message_id]).destroy_all
      redirect "/users/#{@user.id}/messages"
    else
      redirect '/login'
    end
  end

  helpers do
    def next_message
      @user.messages.where("id < ?", params[:message_id]).last
    end

    def previous_message
      @user.messages.where("id > ?", params[:message_id]).first
    end
  end

end