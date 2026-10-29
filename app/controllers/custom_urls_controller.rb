# Custom profile URLs (www.myspace.com/tom). Mounted last in config.ru, so every other
# route and static file wins; paths that don't belong to a user fall through to a 404.
class CustomUrlsController < ApplicationController
  get '/:slug' do
    pass unless params[:slug].match?(/\A[a-zA-Z'-]+\z/)
    user = User.where('lower(url) = ?', params[:slug].downcase).first
    pass if user.nil?
    show_profile(user)
  end
end
