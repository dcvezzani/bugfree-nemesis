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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131127202349) do

  create_table "entries", :force => true do |t|
    t.date     "recorded_for"
    t.string   "title"
    t.text     "yesterdays_log"
    t.text     "todays_log"
    t.text     "show_stopper_log"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "project_id"
  end

  create_table "entry_stories", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "story_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
    t.integer  "project_id"
  end

  create_table "entry_story_work_hours", :force => true do |t|
    t.integer  "entry_story_id"
    t.integer  "work_hour_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "item_notes", :force => true do |t|
    t.integer  "item_id"
    t.integer  "note_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
  end

  create_table "notes", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
  end

  create_table "stories", :force => true do |t|
    t.date     "due_on"
    t.string   "title"
    t.text     "description"
    t.float    "hours_est"
    t.float    "hours_worked"
    t.float    "hours_todo"
    t.date     "stopped_since"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "project_id"
    t.string   "status"
    t.datetime "completed_at"
  end

  create_table "story_work_hours", :force => true do |t|
    t.integer  "story_id"
    t.integer  "work_hour_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "roles_mask"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "work_hours", :force => true do |t|
    t.float    "hours"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "note"
  end

  create_table "work_intervals", :force => true do |t|
    t.integer  "entry_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
  end

end
