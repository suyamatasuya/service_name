# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_09_23_142840) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "care_methods", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "video_links"
    t.text "video_titles"
  end

  create_table "care_methods_symptoms", id: false, force: :cascade do |t|
    t.bigint "symptom_id"
    t.bigint "care_method_id"
    t.index ["care_method_id"], name: "index_care_methods_symptoms_on_care_method_id"
    t.index ["symptom_id"], name: "index_care_methods_symptoms_on_symptom_id"
  end

  create_table "care_records", force: :cascade do |t|
    t.date "date"
    t.string "care_type"
    t.integer "duration"
    t.text "notes"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
    t.boolean "completed"
    t.integer "face_scale"
    t.string "symptom"
    t.index ["user_id"], name: "index_care_records_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favourites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_favourites_on_post_id"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pain_location"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "symptoms", force: :cascade do |t|
    t.bigint "user_id"
    t.string "pain_location"
    t.string "pain_type"
    t.integer "pain_intensity"
    t.string "pain_start_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "injury_related"
    t.string "current_step"
    t.index ["user_id"], name: "index_symptoms_on_user_id"
  end

  create_table "user_care_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "care_method_id", null: false
    t.bigint "symptom_id", null: false
    t.date "care_received_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["care_method_id"], name: "index_user_care_histories_on_care_method_id"
    t.index ["symptom_id"], name: "index_user_care_histories_on_symptom_id"
    t.index ["user_id"], name: "index_user_care_histories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "device_token"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "care_records", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "favourites", "posts"
  add_foreign_key "favourites", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "symptoms", "users"
  add_foreign_key "user_care_histories", "care_methods"
  add_foreign_key "user_care_histories", "symptoms"
  add_foreign_key "user_care_histories", "users"
end
