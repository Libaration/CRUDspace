require './config/environment'
require "carrierwave"
require "carrierwave/orm/activerecord"
require 'sanitize'
#Configure Carrierwave
ActiveRecord::Base.raise_in_transactional_callbacks = true
class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'app/public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  # HTML MySpace allowed in profile fields, comments and blogs: the usual tags plus the
  # period favorites (font, center, marquee...). Scripts, event handlers and javascript:
  # URLs are stripped, and style attributes / <style> blocks go through the CSS sanitizer.
  USER_HTML = Sanitize::Config.merge(Sanitize::Config::RELAXED,
    elements: Sanitize::Config::RELAXED[:elements] + %w(font center marquee blink big),
    attributes: Sanitize::Config.merge(Sanitize::Config::RELAXED[:attributes],
      'a'    => Sanitize::Config::RELAXED[:attributes]['a'] + %w(target),
      'font' => %w(color face size),
      'img'  => Sanitize::Config::RELAXED[:attributes]['img'] + %w(border),
      'table' => Sanitize::Config::RELAXED[:attributes]['table'] + %w(bgcolor border bordercolor cellpadding cellspacing width height align),
      'td'   => Sanitize::Config::RELAXED[:attributes]['td'] + %w(bgcolor width height align valign),
      'marquee' => %w(behavior direction scrollamount)
    )
  )

  get "/" do
    if logged_in?
      redirect "/home"
    else
      redirect "/login"
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @current_user ||= User.find(session[:user_id])
    end

    def require_login
      if !logged_in?
        redirect '/login'
      end
    end

    def user_can_edit?(id)
      redirect '/login' unless current_user == User.find_by_slug(id)
    end

    def set_last_seen_at
      current_user.touch(:last_seen_at)
    end

    # The user's profile address: /tom for users with a custom URL, /users/:id otherwise.
    def profile_path(user)
      user.url.nil? ? "/users/#{user.id}" : "/#{user.url}"
    end

    # Main photo, or MySpace's grey "no pic" placeholder.
    def photo_path(user)
      img = user.images.first
      img.nil? ? "/images/2005/no_pic.gif" : "/images#{img.image}"
    end

    def h(text)
      Rack::Utils.escape_html(text.to_s)
    end

    def online_user_ids
      @online_user_ids ||= User.online.pluck(:id)
    end

    def clean_html(html)
      return html if html.nil?
      Sanitize.fragment(html, USER_HTML)
    end

    # Single-line profile text (name, headline, hometown...): no markup at all.
    def plain_text(text)
      return text if text.nil?
      text.to_s.gsub(/<[^>]*>/, '').delete('<>').strip
    end

    # Plain-textarea input (comments, blog entries): sanitize, then keep line breaks.
    def clean_text(text)
      return text if text.nil?
      clean_html(text.gsub(/\r\n|\r|\n/, "<br />"))
    end

    # Renders a profile (GET /users/:id and custom URLs such as /tom).
    def show_profile(user)
      @user = user
      @profilepic = @user.images.first
      @comments = @user.comments.reverse
      erb :'users/show', :cache => false
    end
  end
end
