class Add2005ProfileFieldsToUsers < ActiveRecord::Migration
  # Fields shown on a 2005 MySpace profile: Interests, Details, Blurbs,
  # Networking and "Last Login".
  def change
    add_column :users, :who_id_like_to_meet, :text

    add_column :users, :interests_general, :text
    add_column :users, :interests_music, :text
    add_column :users, :interests_movies, :text
    add_column :users, :interests_television, :text
    add_column :users, :interests_books, :text
    add_column :users, :interests_heroes, :text

    add_column :users, :status, :string
    add_column :users, :here_for, :string
    add_column :users, :orientation, :string
    add_column :users, :hometown, :string
    add_column :users, :height, :string
    add_column :users, :body_type, :string
    add_column :users, :ethnicity, :string
    add_column :users, :religion, :string
    add_column :users, :zodiac_sign, :string
    add_column :users, :smoke, :string
    add_column :users, :drink, :string
    add_column :users, :children, :string
    add_column :users, :education, :string
    add_column :users, :income, :string
    add_column :users, :occupation, :string

    add_column :users, :networking, :text
    add_column :users, :last_login_at, :datetime
  end
end
