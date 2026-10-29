class FavoritesController < ApplicationController
  before('/favorites') do
    require_login
  end
  before('/users/:id/favorite') do
    require_login
  end
  before('/users/:id/unfavorite') do
    require_login
  end

  # Add to Favorites (from the profile's Contacting box)
  get '/users/:id/favorite' do
    @user = User.find_by_slug(params[:id])
    if @user != current_user
      current_user.favorites.find_or_create_by(favorite_id: @user.id)
    end
    redirect "/users/#{@user.id_or_slug}"
  end

  get '/users/:id/unfavorite' do
    @user = User.find_by_slug(params[:id])
    current_user.favorites.where(favorite_id: @user.id).destroy_all
    redirect '/favorites'
  end

  get '/favorites' do
    @user = current_user
    @favorites = current_user.favorite_users.to_a
    erb :'users/favorites', layout: :template
  end
end
