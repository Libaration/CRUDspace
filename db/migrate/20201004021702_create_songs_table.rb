class CreateSongsTable < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string  "profilesong"
      t.string  "caption"
      t.integer "user_id"
    end
  end
end
