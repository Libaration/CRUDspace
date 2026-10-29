class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorite, class_name: 'User'

  validates :favorite_id, presence: true, uniqueness: { scope: :user_id }
  validate :not_yourself

  private

  def not_yourself
    errors.add(:favorite, "can't be yourself") if favorite_id.present? && favorite_id == user_id
  end
end
