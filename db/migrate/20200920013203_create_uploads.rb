class CreateUploads < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image
      t.string :caption
      t.integer :user_id
    end
  end
end
