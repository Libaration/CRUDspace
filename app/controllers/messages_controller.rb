class MessagesController < ApplicationController
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