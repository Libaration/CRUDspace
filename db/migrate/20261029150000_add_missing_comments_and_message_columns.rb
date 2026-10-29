class AddMissingCommentsAndMessageColumns < ActiveRecord::Migration
  # These existed in schema.rb but no migration ever created them, so a fresh
  # `rake db:migrate` left the app without comments or message subjects.
  # Guarded so databases that already have them are left alone.
  def up
    unless table_exists?(:comments)
      create_table :comments do |t|
        t.string  :content
        t.integer :author_id
        t.integer :user_id
        t.timestamps null: false
      end
    end
    add_column :messages, :subject, :string unless column_exists?(:messages, :subject)
    add_column :messages, :read, :boolean, default: false, null: false unless column_exists?(:messages, :read)
    add_column :messages, :replied, :boolean, default: false, null: false unless column_exists?(:messages, :replied)
  end

  def down
  end
end
