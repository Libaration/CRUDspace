class BlogEntriesController < ApplicationController
  before('/users/:id/blog/new') do
    require_login
    user_can_edit?(params[:id])
  end

  # All of a user's blog entries, newest first
  get '/users/:id/blog' do
    @user = User.find_by_slug(params[:id])
    @entries = @user.blog_entries.order(created_at: :desc, id: :desc).to_a
    erb :'users/blog/index', layout: :template
  end

  get '/users/:id/blog/new' do
    @user = current_user
    @entry = BlogEntry.new
    erb :'users/blog/new', layout: :template
  end

  post '/users/:id/blog' do
    require_login
    user_can_edit?(params[:id])
    @user = current_user
    @entry = @user.blog_entries.build(subject: params[:subject].to_s.strip, body: clean_text(params[:body].to_s.strip))
    if @entry.save
      redirect "/users/#{@user.id_or_slug}/blog/#{@entry.id}"
    else
      @error = 'Please enter a subject for your blog entry.'
      @entry.body = params[:body]
      erb :'users/blog/new', layout: :template
    end
  end

  # One entry ("view more")
  get '/users/:id/blog/:entry_id' do
    @user = User.find_by_slug(params[:id])
    @entry = @user.blog_entries.find_by(id: params[:entry_id])
    pass if @entry.nil?
    erb :'users/blog/show', layout: :template
  end
end
