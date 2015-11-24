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

ActiveRecord::Schema.define(version: 20151122181904) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.boolean  "enabled"
    t.string   "platform"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "payola_affiliates", force: true do |t|
    t.string   "code"
    t.string   "email"
    t.integer  "percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_coupons", force: true do |t|
    t.string   "code"
    t.integer  "percent_off"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: true
  end

  create_table "payola_sales", force: true do |t|
    t.string   "email",                limit: 191
    t.string   "guid",                 limit: 191
    t.integer  "product_id"
    t.string   "product_type",         limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.integer  "amount"
    t.integer  "fee_amount"
    t.integer  "coupon_id"
    t.boolean  "opt_in"
    t.integer  "download_count"
    t.integer  "affiliate_id"
    t.text     "customer_address"
    t.text     "business_address"
    t.string   "stripe_customer_id",   limit: 191
    t.string   "currency"
    t.text     "signed_custom_fields"
    t.integer  "owner_id"
    t.string   "owner_type",           limit: 100
  end

  add_index "payola_sales", ["coupon_id"], name: "index_payola_sales_on_coupon_id", using: :btree
  add_index "payola_sales", ["email"], name: "index_payola_sales_on_email", using: :btree
  add_index "payola_sales", ["guid"], name: "index_payola_sales_on_guid", using: :btree
  add_index "payola_sales", ["owner_id", "owner_type"], name: "index_payola_sales_on_owner_id_and_owner_type", using: :btree
  add_index "payola_sales", ["product_id", "product_type"], name: "index_payola_sales_on_product", using: :btree
  add_index "payola_sales", ["stripe_customer_id"], name: "index_payola_sales_on_stripe_customer_id", using: :btree

  create_table "payola_stripe_webhooks", force: true do |t|
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_subscriptions", force: true do |t|
    t.string   "plan_type"
    t.integer  "plan_id"
    t.datetime "start"
    t.string   "status"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "stripe_customer_id"
    t.boolean  "cancel_at_period_end"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "ended_at"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "canceled_at"
    t.integer  "quantity"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.string   "state"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.integer  "amount"
    t.string   "guid",                 limit: 191
    t.string   "stripe_status"
    t.integer  "affiliate_id"
    t.string   "coupon"
    t.text     "signed_custom_fields"
    t.text     "customer_address"
    t.text     "business_address"
    t.integer  "setup_fee"
  end

  add_index "payola_subscriptions", ["guid"], name: "index_payola_subscriptions_on_guid", using: :btree

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

  create_table "rpush_apps", force: true do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: true do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: true do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                        default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                       default: 86400
    t.boolean  "delivered",                    default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                       default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                default: false
    t.string   "type",                                             null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",             default: false,     null: false
    t.text     "registration_ids"
    t.integer  "app_id",                                           null: false
    t.integer  "retries",                      default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                   default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
  end

  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree

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
    t.integer  "multiplier"
    t.integer  "days_since_signup"
    t.integer  "user_id"
    t.integer  "mood_checkin_count"
    t.datetime "mood_last_checkin_date"
    t.integer  "mood_streak_count"
    t.integer  "mood_streak_record"
    t.integer  "mood_multiplier"
    t.integer  "sleep_checkin_count"
    t.datetime "sleep_last_checkin_date"
    t.integer  "sleep_streak_count"
    t.integer  "sleep_streak_record"
    t.integer  "sleep_multiplier"
    t.integer  "self_care_checkin_count"
    t.datetime "self_care_last_checkin_date"
    t.integer  "self_care_streak_count"
    t.integer  "self_care_streak_record"
    t.integer  "self_care_multiplier"
    t.integer  "journal_checkin_count"
    t.datetime "journal_last_checkin_date"
    t.integer  "journal_streak_count"
    t.integer  "journal_streak_record"
    t.integer  "journal_multiplier"
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
    t.integer  "player_rank"
    t.integer  "mood_base_value"
    t.integer  "mood_base_perk_register"
    t.integer  "mood_multiplier_perk_register"
    t.integer  "mood_streak_base_value"
    t.integer  "mood_streak_perk_register"
    t.integer  "sleep_base_value"
    t.integer  "sleep_base_perk_register"
    t.integer  "sleep_multiplier_perk_register"
    t.integer  "sleep_streak_base_value"
    t.integer  "sleep_streak_perk_register"
    t.integer  "self_care_base_value"
    t.integer  "self_care_base_perk_register"
    t.integer  "self_care_multiplier_perk_register"
    t.integer  "self_care_streak_base_value"
    t.integer  "self_care_streak_perk_register"
    t.integer  "journal_base_value"
    t.integer  "journal_base_perk_register"
    t.integer  "journal_multiplier_perk_register"
    t.integer  "journal_streak_base_value"
    t.integer  "journal_streak_perk_register"
    t.integer  "player_perk_trigger"
    t.integer  "player_perks_earned"
    t.integer  "player_perks_available"
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
    t.integer  "thrivers",               default: [],                                        array: true
    t.string   "uuid"
    t.string   "connect_uuid"
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
