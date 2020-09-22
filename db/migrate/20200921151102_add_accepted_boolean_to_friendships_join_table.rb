class AddAcceptedBooleanToFriendshipsJoinTable < ActiveRecord::Migration
  def change
    add_column :friendships, :accepted, :boolean, null: false, default: false
  end
end
