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

ActiveRecord::Schema.define(:version => 20121019100147) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "banners", :force => true do |t|
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "banners", ["show_id"], :name => "index_banners_on_show_id"

  create_table "constants", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.string   "additional_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "constants", ["key"], :name => "index_constants_on_key"

  create_table "crons", :force => true do |t|
    t.string   "title"
    t.integer  "every"
    t.string   "interval"
    t.integer  "at"
    t.string   "am_pm"
    t.text     "command"
    t.string   "command_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crons", ["title"], :name => "index_crons_on_title"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
  end

  create_table "episodes", :force => true do |t|
    t.integer  "show_id"
    t.integer  "api_episode_id"
    t.integer  "season_id"
    t.integer  "season_number"
    t.integer  "number"
    t.string   "name"
    t.datetime "air_date"
    t.text     "overview"
    t.float    "rating"
    t.integer  "api_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "episodes", ["api_episode_id"], :name => "episode_must_be_unique", :unique => true
  add_index "episodes", ["show_id", "air_date"], :name => "index_episodes_on_show_id_and_a"

  create_table "faqs", :force => true do |t|
    t.text     "question"
    t.text     "answer"
    t.integer  "position",   :default => 0
    t.boolean  "important",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "show_id"
    t.boolean  "send_reminder"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "marked_episodes_count", :default => 0
    t.integer  "hidden_episodes_count", :default => 0
    t.boolean  "watch_later",           :default => false
  end

  create_table "hidden_episodes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "season_id"
    t.integer  "episode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hidden_episodes", ["user_id", "season_id"], :name => "index_hidden_episodes_on_user_id_and_season_id"
  add_index "hidden_episodes", ["user_id"], :name => "index_hidden_episodes_on_user_id"

  create_table "logs", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.text     "additional_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["key"], :name => "index_logs_on_key"

  create_table "mail_balancers", :force => true do |t|
    t.integer  "usage_count"
    t.string   "username"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", :force => true do |t|
    t.integer  "api_show_id"
    t.integer  "number"
    t.integer  "episodes_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seasons", ["api_show_id"], :name => "index_seasons_on_api_show_id"

  create_table "seen_episodes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "season_id"
    t.integer  "episode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seen_episodes", ["user_id", "season_id"], :name => "index_seen_episodes_on_user_id_"
  add_index "seen_episodes", ["user_id"], :name => "index_seen_episodes_on_user_id"

  create_table "show_attribute_votes", :force => true do |t|
    t.integer  "show_id"
    t.integer  "user_id"
    t.string   "show_attribute"
    t.string   "attribute_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", :force => true do |t|
    t.integer  "api_show_id"
    t.string   "name"
    t.string   "permalink"
    t.text     "overview"
    t.string   "status"
    t.datetime "first_aired"
    t.integer  "air_time_hour",                     :default => 0
    t.integer  "day_of_week"
    t.integer  "runtime",                           :default => 0
    t.string   "network"
    t.string   "imdb_id"
    t.integer  "followers",                         :default => 0
    t.integer  "current_trend_position"
    t.integer  "previous_trend_position"
    t.integer  "previous_trend_position_followers"
    t.integer  "seasons_count",                     :default => 0
    t.integer  "episodes_count",                    :default => 0
    t.integer  "api_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shows", ["api_show_id"], :name => "show_must_be_unique", :unique => true
  add_index "shows", ["followers"], :name => "index_shows_on_followers"
  add_index "shows", ["name"], :name => "index_shows_on_name"
  add_index "shows", ["status"], :name => "index_shows_on_status"

  create_table "statistics", :force => true do |t|
    t.string   "key"
    t.integer  "value"
    t.string   "additional_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.string   "from"
    t.string   "email"
    t.string   "category"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "update_queues", :force => true do |t|
    t.integer  "api_id"
    t.string   "update_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "update_queues", ["update_type"], :name => "index_update_queues_on_update_t"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password",         :limit => 40
    t.string   "password_salt",              :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.string   "confirmation_token",         :limit => 40
    t.datetime "confirmed_at"
    t.integer  "show_format",                              :default => 1
    t.integer  "episode_format",                           :default => 1
    t.string   "reset_password_token"
    t.boolean  "admin",                                    :default => false
    t.integer  "followings_count",                         :default => 0
    t.string   "time_zone",                                :default => "UTC"
    t.boolean  "sun_to_sat",                               :default => false
    t.boolean  "daily_notification",                       :default => false
    t.boolean  "weekly_notification",                      :default => false
    t.boolean  "only_premiere_notification",               :default => false
    t.boolean  "hide_profile",                             :default => false
    t.boolean  "hide_overview_in_rss",                     :default => false
    t.string   "authentication_token"
    t.datetime "confirmation_sent_at"
    t.integer  "sign_in_count",                            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "day_offset",                               :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_t", :unique => true

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false, :null => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
