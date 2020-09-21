class User < ActiveRecord::Base
  has_secure_password
  has_many :images, class_name: 'Images'
  has_many :friendships, -> { where(accepted: true)}
  has_many :pending_friendships, -> { where(accepted: false)}, class_name: Friendship
  has_many :friends, through: :friendships
  has_many :pending_friends, through: :pending_friendships, :source => :user
end
