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

ActiveRecord::Schema.define(version: 20140402101937) do

  create_table "admins", force: :cascade do |t|
    t.string   "provider",      limit: 255
    t.string   "uid",           limit: 255
    t.string   "name",          limit: 255
    t.string   "refresh_token", limit: 255
    t.string   "access_token",  limit: 255
    t.datetime "expires"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",         limit: 255
    t.boolean  "super_admin",               default: false
  end

  create_table "assigned_quizzes", force: :cascade do |t|
    t.decimal  "score",                        precision: 12, scale: 2
    t.integer  "user_id",            limit: 4
    t.integer  "quiz_id",            limit: 4
    t.boolean  "attempted",                                             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time",               limit: 4,                          default: 0
    t.integer  "number_of_attempts", limit: 4,                          default: 0
  end

  add_index "assigned_quizzes", ["quiz_id"], name: "index_assigned_quizzes_on_quiz_id", using: :btree
  add_index "assigned_quizzes", ["user_id"], name: "index_assigned_quizzes_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "parent_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "questions_count", limit: 4,   default: 0
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "difficulty_levels", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "questions_count", limit: 4,   default: 0
  end

  create_table "options", force: :cascade do |t|
    t.text     "value",       limit: 65535
    t.integer  "question_id", limit: 4
    t.boolean  "answer",                    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "options", ["question_id"], name: "index_options_on_question_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "type",                limit: 255
    t.text     "content",             limit: 65535
    t.integer  "category_id",         limit: 4
    t.integer  "difficulty_level_id", limit: 4
    t.string   "status",              limit: 255
    t.integer  "points",              limit: 4,     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "successful_hits",     limit: 4,     default: 0
    t.integer  "total_hits",          limit: 4,     default: 0
    t.string   "image_file_name",     limit: 255
    t.string   "image_content_type",  limit: 255
    t.integer  "image_file_size",     limit: 4
    t.datetime "image_updated_at"
    t.integer  "admin_id",            limit: 4
    t.text     "answer_description",  limit: 65535
  end

  add_index "questions", ["admin_id"], name: "index_questions_on_admin_id", using: :btree
  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree
  add_index "questions", ["difficulty_level_id"], name: "index_questions_on_difficulty_level_id", using: :btree

  create_table "questions_quizzes", id: false, force: :cascade do |t|
    t.integer "question_id", limit: 4
    t.integer "quiz_id",     limit: 4
  end

  add_index "questions_quizzes", ["question_id"], name: "index_questions_quizzes_on_question_id", using: :btree
  add_index "questions_quizzes", ["quiz_id"], name: "index_questions_quizzes_on_quiz_id", using: :btree

  create_table "quizzes", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "passcode",            limit: 255
    t.text     "instructions",        limit: 65535
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.decimal  "negative_marking",                  precision: 5, default: 0
    t.boolean  "shuffle_questions"
    t.boolean  "shuffle_options"
    t.integer  "number_of_questions", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "attemptable",                                     default: false
    t.string   "code",                limit: 255
    t.integer  "duration",            limit: 4,                   default: 0
    t.integer  "marks",               limit: 4,                   default: 0
    t.integer  "admin_id",            limit: 4
  end

  add_index "quizzes", ["admin_id"], name: "index_quizzes_on_admin_id", using: :btree
  add_index "quizzes", ["code"], name: "index_quizzes_on_code", using: :btree
  add_index "quizzes", ["passcode"], name: "index_quizzes_on_passcode", using: :btree

  create_table "responses", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "question_id", limit: 4
    t.integer  "option_id",   limit: 4
    t.integer  "quiz_id",     limit: 4
    t.string   "answer",      limit: 255
    t.boolean  "attempted",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "correct",                 default: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "contact_number",         limit: 255
    t.string   "college_name",           limit: 255
    t.string   "enrollment_number",      limit: 255
    t.string   "engineering_branch",     limit: 255
    t.boolean  "deleted",                            default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
