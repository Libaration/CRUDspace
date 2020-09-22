class MessagesController < ApplicationController
  get '/user/:id/messages/:message_id' do
    @user = User.find(params[:id])
    @message = User.find(params[:id]).messages.where(id: params[:message_id]).first
    if logged_in? && @user == current_user
      erb :'/user/messages/show', layout: :template
    else
      redirect '/login'
    end
  end
end