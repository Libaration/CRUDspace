class User < ActiveRecord::Base
  has_secure_password
  has_many :images, class_name: 'Images'
  has_many :friendships, -> { where(accepted: true)}
  has_many :pending_friendships, -> { where(accepted: false)}, class_name: Friendship
  has_many :friends, through: :friendships
  has_many :pending_friends, through: :pending_friendships, :source => :friend
  has_many :messages, class_name: 'Message', foreign_key: :receiver_id
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
  has_many :unread_messages, -> {where(read: false)}, class_name: Message, foreign_key: :receiver_id
  has_many :comments
  has_one :song

  def self.find_by_slug(slug)
    User.find_by(url: slug.downcase) || User.find(slug)
  end

  def id_or_slug
    if self.url == nil
      self.id
    else
      self.url
    end
  end

end
