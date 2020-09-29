class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :author, class_name: 'User'
end
