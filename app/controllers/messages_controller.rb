class MessagesController < ApplicationController
  get '/user/:id/messages/:message_id' do
    @user = User.find(params[:id])
    @message = Message.find(params[:message_id])
    if logged_in? && @user == current_user && @message.receiver == current_user
      # @message = User.find(params[:id]).messages.where(id: params[:message_id]).first
      erb :'/user/messages/show', layout: :template
    else
      redirect '/login'
    end
  end
end