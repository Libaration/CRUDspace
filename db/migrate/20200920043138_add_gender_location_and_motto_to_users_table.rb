class AddGenderLocationAndMottoToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :country, :string
    add_column :users, :motto, :string
  end
end
