# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200922024603) do

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.boolean "accepted",  default: false, null: false
  end

  create_table "images", force: :cascade do |t|
    t.string  "image"
    t.string  "caption"
    t.integer "user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.integer  "reciever_id"
    t.integer  "sender_id"
    t.datetime "time"
  end

  create_table "users", force: :cascade do |t|
    t.string  "name"
    t.string  "username"
    t.integer "age"
    t.string  "bio"
    t.string  "password_digest"
    t.string  "gender"
    t.string  "city"
    t.string  "state"
    t.string  "country"
    t.string  "motto"
  end

end
