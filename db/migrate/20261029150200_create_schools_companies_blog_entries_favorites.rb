class CreateSchoolsCompaniesBlogEntriesFavorites < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.integer :user_id
      t.string  :name
      t.string  :location
      t.string  :grad_year
      t.string  :student_status
      t.string  :degree
      t.string  :major
      t.string  :clubs
      t.string  :start_year
      t.string  :end_year
      t.timestamps null: false
    end

    create_table :companies do |t|
      t.integer :user_id
      t.string  :name
      t.string  :location
      t.string  :start_year
      t.string  :end_year
      t.timestamps null: false
    end

    create_table :blog_entries do |t|
      t.integer :user_id
      t.string  :subject
      t.text    :body
      t.timestamps null: false
    end

    create_table :favorites do |t|
      t.integer :user_id
      t.integer :favorite_id
      t.timestamps null: false
    end
  end
end
