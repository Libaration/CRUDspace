require './app/controllers/images_uploader'
class UsersController < ApplicationController
  # Fields a user may change from Edit Profile (PATCH /users/:id). Everything else
  # (username, url, password_digest, last_login_at...) is off limits.
  EDITABLE_FIELDS = %w(
    name age motto gender city state country
    bio who_id_like_to_meet
    interests_general interests_music interests_movies interests_television interests_books interests_heroes
    status orientation hometown height body_type ethnicity religion zodiac_sign
    smoke drink children education income occupation networking
  )
  # Fields that may hold HTML (shown raw on the profile, like MySpace did).
  HTML_FIELDS = %w(
    bio who_id_like_to_meet
    interests_general interests_music interests_movies interests_television interests_books interests_heroes
  )
  # Fields accepted from the signup form (POST /users).
  SIGNUP_FIELDS = %w(username name password gender age city state country bio motto)
  # Choices for the Edit Profile selects (2005 MySpace's lists). "No Answer" (blank) hides
  # the row on the profile; a stored value missing from a list is kept as an extra option.
  PROFILE_CHOICES = {
    'gender'      => [['male', 'Male'], ['female', 'Female'], ['non-binary', 'Non-Binary']],
    'status'      => ['Single', 'In a Relationship', 'Divorced', 'Married', 'Swinger'],
    'here_for'    => ['Dating', 'Serious Relationships', 'Friends', 'Networking'],
    'orientation' => ['Straight', 'Gay', 'Bi', 'Not Sure'],
    'height'      => (54..84).map { |inches| %Q(#{inches / 12}' #{inches % 12}") },
    'body_type'   => ['Slim / Slender', 'Average', 'Athletic', 'Some extra baggage', 'More to love!', 'Body builder'],
    'ethnicity'   => ['Asian', 'Black / African descent', 'East Indian', 'Latino / Hispanic', 'Middle Eastern',
                      'Native American', 'Pacific Islander', 'White / Caucasian', 'Other'],
    'religion'    => ['Agnostic', 'Atheist', 'Buddhist', 'Catholic', 'Christian - other', 'Hindu', 'Jewish',
                      'Mormon', 'Muslim', 'Protestant', 'Scientologist', 'Taoist', 'Wiccan', 'Other'],
    'zodiac_sign' => ['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio',
                      'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'],
    'smoke'       => ['No', 'Yes'],
    'drink'       => ['No', 'Yes'],
    'children'    => ["I don't want kids", 'Someday', 'Undecided', 'Love kids, but not for me', 'Proud parent'],
    'education'   => ['High school', 'Some college', 'In college', 'College graduate',
                      'Grad / professional school', 'Post grad', "I'm an open book"],
    'income'      => ['Less than $30,000', '$30,000 to $45,000', '$45,000 to $60,000', '$60,000 to $75,000',
                      '$75,000 to $100,000', '$100,000 to $150,000', '$150,000 to $250,000', '$250,000 and Higher'],
    'student_status' => ['Alumni', 'Undergrad', 'Grad Student', 'Current Student'],
    'degree'      => ["High School Diploma", "Associate's Degree", "Bachelor's Degree", "Master's Degree",
                      'Doctorate', 'Professional Degree', 'Certificate']
  }
  # Custom URLs that would collide with the site's own top-level paths.
  RESERVED_URLS = %w(
    home login logout users favorites signup join help search browse mail blog
    images stylesheets javascripts profile_css uploads favicon
  )

  before('*') do
    set_last_seen_at if logged_in?
  end

  get '/users/new' do
    if !logged_in?
      erb :'users/new', :layout => :home_layout
    else
      redirect "/home"
    end
  end

  get '/home' do
    require_login
    @user = current_user
    @profilepic = @user.images.first
    @friends = @user.friends.to_a
    @unread_count = @user.unread_messages.count
    @pending_count = @user.pending_friends.count
    @blog_entries = @user.blog_entries.order(created_at: :desc).limit(5)
    @favorites_count = @user.favorites.count
    erb :'users/home', :layout => :template
  end

  get '/users/:id/url/edit' do
    @user = User.find_by_slug(params[:id])
    @error = ""
    if logged_in? && @user == current_user && @user.url.nil?
      erb :'users/url/edit' , :layout => :template
    else
      "You have already set a custom URL"
    end
  end

  patch '/users/:id/url' do
    @user = User.find_by_slug(params[:id])
    if logged_in? && @user == current_user && @user.url.nil?
      url = params[:url].to_s.downcase
      if params[:url] == params[:urlconfirm] && url.match?(/\A[a-z'-]+\z/) && !RESERVED_URLS.include?(url) && User.where('lower(url) = ?', url).empty?
        @user.url = url
        @user.save
        redirect "/#{@user.url}"
      else
        @error = "Fields do not match, URL taken, or URL contains invalid characters/spaces"
        erb :'users/url/edit' , :layout => :template
      end
    else
      redirect '/login'
    end
  end

  get '/users/online' do
    @users = User.online
    erb :'users/online', :layout => :template
  end

  get '/users/:id' do
    show_profile(User.find_by_slug(params[:id]))
  end

  post '/users' do
    fields = params.select { |key, _| SIGNUP_FIELDS.include?(key) }
    fields.each_key { |field| fields[field] = plain_text(fields[field]) unless %w(password bio).include?(field) }
    fields['bio'] = clean_html(fields['bio']) if fields.key?('bio')
    if (SIGNUP_FIELDS - %w(bio motto)).any? { |field| fields[field].to_s.strip.empty? }
      @error = 'All values except bio and motto are required'
    elsif params[:file].nil? || !params[:file].is_a?(Hash) || !params[:file][:type].to_s.include?("image")
      @error = 'Profile picture is required!'
    elsif !User.find_by(username: params[:username]).nil?
      @error = 'Username already exists'
    else
      @user = User.new(fields)
      @user.last_login_at = Time.now
      if @user.save
        tomswelcome(@user)
        img = Images.new
        img.image  = params[:file] #carrierwave uploads using params here
        img.user = @user
        img.save!
        session[:user_id] = @user.id
        redirect "/home"
      else
        @error = @user.errors.full_messages.join(', ')
      end
    end
    erb :'users/new', :layout => :home_layout
  end

  get '/login' do
    @users = User.order(id: :desc).limit(2)
    redirect "/home" if logged_in?
    erb :'users/login', :layout => :home_layout
  end

  post'/login' do
    if (@user = User.find_by(username: params[:username])) && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      @user.update_column(:last_login_at, Time.now)
      redirect "/home"
    else
      @error = 'One of the fields was incorrect'
      erb :'users/login', :layout => :home_layout

    end

  end

  get '/users/:id/edit' do
    @user = User.find_by_slug(params[:id])
    if logged_in? && @user == current_user
      if Pathname("./app/public/profile_css/#{@user.id}_custom_css.css").exist?
        @custom_css = File.read("./app/public/profile_css/#{@user.id}_custom_css.css")
      end
      @schools = @user.schools.order(:id)
      @companies = @user.companies.order(:id)
      erb :'users/edit', layout: :template
    else
      'You do not have permission to view this page'
    end
  end

  patch '/users/:id' do
    @user = User.find_by_slug(params[:id])
    if logged_in? && @user == current_user
      attributes = params.select { |key, _| EDITABLE_FIELDS.include?(key) }
      # "Here for" is a set of checkboxes, stored the way the profile shows it.
      attributes['here_for'] = Array(params[:here_for]).reject(&:blank?).join(', ') if params.key?('here_for_sent')
      attributes.each_key do |field|
        attributes[field] = HTML_FIELDS.include?(field) ? clean_html(attributes[field]) : plain_text(attributes[field])
      end
      attributes['networking'] = attributes['networking'].gsub(/\r\n?/, "\n") if attributes.key?('networking')
      @user.update(attributes)

      if params.key?('css')
        # Real 2005 layout codes target the profile's own markup and myspace.css classes,
        # so the stylesheet is only sanitized, not rewritten.
        path = "./app/public/profile_css/#{@user.id}_custom_css.css"
        content = Sanitize::CSS.stylesheet(params[:css].to_s, Sanitize::Config::RELAXED)
        File.open(path, "w+") do |f|
          f.write(content)
        end
      end

      redirect "/users/#{@user.id_or_slug}"
    else
      'You do not have permission to view this page'
    end
  end

  post '/users/:id/schools' do
    @user = User.find_by_slug(params[:id])
    if logged_in? && @user == current_user
      fields = params.select { |key, _| %w(name location grad_year student_status degree major clubs start_year end_year).include?(key) }
      fields.each_key { |field| fields[field] = plain_text(fields[field]) }
      @user.schools.create(fields) unless fields['name'].to_s.strip.empty?
      redirect "/users/#{@user.id_or_slug}/edit#schools"
    else
      'You do not have permission to perform this action'
    end
  end

  delete '/users/:id/schools/:school_id' do
    @user = User.find_by_slug(params[:id])
    if logged_in? && @user == current_user
      school = @user.schools.find_by(id: params[:school_id])
      school.destroy if school
      redirect "/users/#{@user.id_or_slug}/edit#schools"
    else
      'You do not have permission to perform this action'
    end
  end

  post '/users/:id/companies' do
    @user = User.find_by_slug(params[:id])
    if logged_in? && @user == current_user
      fields = params.select { |key, _| %w(name location start_year end_year).include?(key) }
      fields.each_key { |field| fields[field] = plain_text(fields[field]) }
      @user.companies.create(fields) unless fields['name'].to_s.strip.empty?
      redirect "/users/#{@user.id_or_slug}/edit#companies"
    else
      'You do not have permission to perform this action'
    end
  end

  delete '/users/:id/companies/:company_id' do
    @user = User.find_by_slug(params[:id])
    if logged_in? && @user == current_user
      company = @user.companies.find_by(id: params[:company_id])
      company.destroy if company
      redirect "/users/#{@user.id_or_slug}/edit#companies"
    else
      'You do not have permission to perform this action'
    end
  end

  get '/logout' do
    if logged_in?
      current_user.update(last_seen_at: nil)
      session.clear
    end
    redirect '/login'
  end

  get '/users' do
    if params[:search]
      @users = User.where("name like ?", "%#{params[:search]}%")
    else
      @users = User.all
    end

    erb :'users/all_users', :layout => :template
  end

  helpers do
    # <select> for an Edit Profile field. Choices are strings or [value, label] pairs.
    def profile_select(name, current, blank = '-- No Answer --')
      choices = PROFILE_CHOICES[name.sub(/\[\]\z/, '')].map { |c| c.is_a?(Array) ? c : [c, c] }
      choices.unshift([current, current]) if current.present? && choices.none? { |value, _| value == current }
      html = %(<select name="#{name}">)
      html << %(<option value="">#{h blank}</option>) if blank
      choices.each do |value, label|
        html << %(<option value="#{h value}"#{' selected' if value == current}>#{h label}</option>)
      end
      html << '</select>'
    end

    def tomswelcome(user)
      @tom = User.find(1)
      user.friends << @tom
      @tom.friends << @user
      @message = Message.create(subject: "Welcome!", content: "Welcome to CRUDSpace! Message me if you run into any issues!", sender: @tom)
      @message.update(receiver: user)
    end
  end

end
