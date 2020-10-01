class CommentsController < ApplicationController
  post '/users/:id/comments/new' do
    if logged_in?
      @user = User.find(params[:id])
      Comment.create(content: params[:content]).tap do |comment|
        comment.user = @user
        comment.author = current_user
        comment.save
      end
      redirect "/users/#{@user.id}"
    else
      'You must be logged in to perform this action'
    end
  end
end