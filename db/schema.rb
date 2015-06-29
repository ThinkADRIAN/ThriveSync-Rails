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

ActiveRecord::Schema.define(version: 20150629193706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendships", force: true do |t|
    t.integer "friendable_id"
    t.integer "friend_id"
    t.integer "blocker_id"
    t.boolean "pending",       default: true
  end

  add_index "friendships", ["friendable_id", "friend_id"], name: "index_friendships_on_friendable_id_and_friend_id", unique: true, using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "journals", force: true do |t|
    t.text     "journal_entry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "timestamp"
  end

  create_table "moods", force: true do |t|
    t.integer  "mood_rating"
    t.integer  "anxiety_rating"
    t.integer  "irritability_rating"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "relation_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reminders", force: true do |t|
    t.integer  "user_id"
    t.string   "message"
    t.time     "alert_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sunday_enabled"
    t.boolean  "monday_enabled"
    t.boolean  "tuesday_enabled"
    t.boolean  "wednesday_enabled"
    t.boolean  "thursday_enabled"
    t.boolean  "friday_enabled"
    t.boolean  "saturday_enabled"
  end

  create_table "reviews", force: true do |t|
    t.integer  "review_counter"
    t.datetime "review_last_date"
    t.datetime "review_trigger_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "rewards", force: true do |t|
    t.integer  "user_id"
    t.boolean  "rewards_enabled", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scorecards", force: true do |t|
    t.integer  "checkin_count"
    t.integer  "perfect_checkin_count"
    t.datetime "last_checkin_date"
    t.integer  "streak_count"
    t.integer  "streak_record"
    t.integer  "moods_score"
    t.integer  "sleeps_score"
    t.integer  "self_cares_score"
    t.integer  "journals_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level_multiplier"
    t.integer  "days_since_signup"
    t.integer  "user_id"
    t.integer  "mood_checkin_count"
    t.datetime "mood_last_checkin_date"
    t.integer  "mood_streak_count"
    t.integer  "mood_streak_record"
    t.integer  "mood_level_multiplier"
    t.integer  "sleep_checkin_count"
    t.datetime "sleep_last_checkin_date"
    t.integer  "sleep_streak_count"
    t.integer  "sleep_streak_record"
    t.integer  "sleep_level_multiplier"
    t.integer  "self_care_checkin_count"
    t.datetime "self_care_last_checkin_date"
    t.integer  "self_care_streak_count"
    t.integer  "self_care_streak_record"
    t.integer  "self_care_level_multiplier"
    t.integer  "journal_checkin_count"
    t.datetime "journal_last_checkin_date"
    t.integer  "journal_streak_count"
    t.integer  "journal_streak_record"
    t.integer  "journal_level_multiplier"
    t.integer  "total_score"
    t.datetime "last_perfect_checkin_date"
  end

  create_table "self_cares", force: true do |t|
    t.boolean  "counseling"
    t.boolean  "medication"
    t.boolean  "meditation"
    t.boolean  "exercise"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "timestamp"
  end

  create_table "sleeps", force: true do |t|
    t.datetime "start_time"
    t.datetime "finish_time"
    t.integer  "quality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "time"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "clients",                default: [],              array: true
    t.string   "authentication_token"
    t.datetime "last_active_at"
    t.string   "timezone"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
