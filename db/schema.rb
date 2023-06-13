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

ActiveRecord::Schema.define(version: 2023_06_13_131800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "symptoms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "pain_location"
    t.string "pain_type"
    t.integer "pain_intensity"
    t.datetime "pain_start_time"
    t.integer "pain_duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "injury_related"
    t.index ["user_id"], name: "index_symptoms_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.time "notification_time"
    t.string "device_token"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "symptoms", "users"
end
