class Friendship < ActiveRecord::Base
  #the join table
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  # saying belongs to user twice confused active record this alias seems to work though.
end
