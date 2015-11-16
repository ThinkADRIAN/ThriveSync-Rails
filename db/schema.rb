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

ActiveRecord::Schema.define(version: 20151116142628) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "flipper_features", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "flipper_features", ["name"], name: "index_flipper_features_on_name", unique: true, using: :btree

  create_table "flipper_gates", force: true do |t|
    t.integer  "flipper_feature_id", null: false
    t.string   "name",               null: false
    t.string   "value"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "flipper_gates", ["flipper_feature_id", "name", "value"], name: "index_flipper_gates_on_flipper_feature_id_and_name_and_value", unique: true, using: :btree

  create_table "friendships", force: true do |t|
    t.integer  "friendable_id"
    t.string   "friendable_type"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "parse_object_id"
  end

  create_table "mailboxer_conversation_opt_outs", force: true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree

  create_table "mailboxer_conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type", using: :btree

  create_table "mailboxer_receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "moods", force: true do |t|
    t.integer  "mood_rating"
    t.integer  "anxiety_rating"
    t.integer  "irritability_rating"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "parse_object_id"
  end

  create_table "pre_defined_cards", force: true do |t|
    t.string   "text"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.boolean  "rewards_enabled", default: false
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
    t.integer  "streak_multiplier"
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
    t.integer  "checkin_goal"
    t.boolean  "checkin_sunday"
    t.boolean  "checkin_monday"
    t.boolean  "checkin_tuesday"
    t.boolean  "checkin_wednesday"
    t.boolean  "checkin_thursday"
    t.boolean  "checkin_friday"
    t.boolean  "checkin_saturday"
    t.integer  "checkins_to_reach_goal"
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
    t.string   "parse_object_id"
  end

  create_table "sleeps", force: true do |t|
    t.datetime "start_time"
    t.datetime "finish_time"
    t.integer  "quality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "time"
    t.string   "parse_object_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",                           null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                            null: false
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
    t.integer  "clients",                default: [],                                        array: true
    t.string   "authentication_token"
    t.datetime "last_active_at"
    t.string   "timezone",               default: "Eastern Time (US & Canada)"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "supporters",             default: [],                                        array: true
    t.datetime "research_started_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "flipper_gates", "flipper_features", name: "flipper_gates_flipper_feature_id_fk"

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", name: "mb_opt_outs_on_conversations_id", column: "conversation_id"

  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", name: "notifications_on_conversation_id", column: "conversation_id"

  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", name: "receipts_on_notification_id", column: "notification_id"

end
