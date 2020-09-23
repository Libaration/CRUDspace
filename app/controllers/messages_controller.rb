class MessagesController < ApplicationController

  post'/user/:id/messages' do
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
      redirect "/user/#{@user.id}/messages"
    else
      redirect '/login'
    end
  end

  get'/user/:id/messages/:msg_id/reply' do
    @user = User.find(params[:id])
    @message = Message.find(params[:msg_id])
    if logged_in? && @user == current_user && @message.receiver == current_user
      erb :'user/messages/new', layout: :template
    else
      redirect '/login'
    end
  end

  get '/user/:id/messages/:message_id' do
    @user = User.find(params[:id])
    @message = Message.find(params[:message_id])
    @messages = @user.messages
    if logged_in? && @user == current_user && @message.receiver == current_user
      @message.update(read: true)
      # @message = User.find(params[:id]).messages.where(id: params[:message_id]).first
      erb :'/user/messages/show', layout: :template
    else
      redirect '/login'
    end
  end

  get '/user/:id/messages' do
    @user = User.find(params[:id])
    @messages = @user.messages
    if logged_in? && @user == current_user
      erb :'/user/messages/home', layout: :template
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