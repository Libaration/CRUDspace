class CommentsController < ApplicationController
  # View/Edit All Comments
  get '/users/:id/comments' do
    @user = User.find_by_slug(params[:id])
    @comments = @user.comments.includes(:author).order(created_at: :desc, id: :desc).to_a
    erb :'users/comments/index', layout: :template
  end

  # Add Comment page
  get '/users/:id/comments/new' do
    require_login
    @user = User.find_by_slug(params[:id])
    erb :'users/comments/new', layout: :template
  end

  post '/users/:id/comments/new' do
    if logged_in?
      @user = User.find_by_slug(params[:id])
      if params[:content].to_s.strip.empty?
        @error = 'Please enter a comment.'
        return erb :'users/comments/new', layout: :template
      end
      Comment.create(content: clean_text(params[:content].to_s.strip), user: @user, author: current_user)
      redirect "/users/#{@user.id_or_slug}"
    else
      'You must be logged in to perform this action'
    end
  end

  # The profile owner (or the comment's author) can delete a comment.
  delete '/users/:id/comments/:comment_id' do
    require_login
    @user = User.find_by_slug(params[:id])
    comment = @user.comments.find_by(id: params[:comment_id])
    comment.destroy if comment && (current_user == @user || comment.author == current_user)
    redirect "/users/#{@user.id_or_slug}/comments"
  end
end
