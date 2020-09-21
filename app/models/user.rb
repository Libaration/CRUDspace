class User < ActiveRecord::Base
  has_secure_password
  has_many :images, class_name: 'Images'
  has_many :friendships, -> { where(accepted: true)}
  has_many :friends, through: :friendships
end
