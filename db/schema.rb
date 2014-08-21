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

ActiveRecord::Schema.define(version: 20140303212136) do

  create_table "dropbox_authenticates", force: true do |t|
    t.integer  "user_id"
    t.string   "dropbox_id"
    t.string   "access_token"
    t.integer  "deleted",      limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dropbox_name"
    t.string   "country",      limit: 2
  end

  create_table "facebook_authenticates", force: true do |t|
    t.integer  "user_id"
    t.string   "facebook_id"
    t.string   "access_token"
    t.string   "facebook_name"
    t.string   "facebook_email"
    t.integer  "deleted",        limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_friends", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_user_id"
    t.integer  "facebook_authenticate_id"
    t.string   "facebook_id"
    t.string   "facebook_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_friends", ["facebook_id"], name: "index_facebook_friends_on_facebook_id", using: :btree
  add_index "facebook_friends", ["user_id"], name: "index_facebook_friends_on_user_id", using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "transfer_histories", force: true do |t|
    t.integer  "send_user_id"
    t.integer  "receive_user_id"
    t.integer  "state",           limit: 1
    t.string   "filename"
    t.string   "image"
    t.text     "api_response"
    t.integer  "deleted",         limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "file_size",                 default: 0
  end

  create_table "users", force: true do |t|
    t.string   "ip"
    t.integer  "state",              limit: 1
    t.integer  "deleted",            limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delete_reason_type", limit: 1
    t.text     "delete_reason"
  end

end
