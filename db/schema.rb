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

ActiveRecord::Schema[7.1].define(version: 2025_04_08_161224) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "corporate_profiles", force: :cascade do |t|
    t.string "business_name"
    t.text "description"
    t.string "business_hours"
    t.text "about"
    t.string "logo"
    t.text "address"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_corporate_profiles_on_user_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.integer "free_listings_count"
    t.integer "max_photos_per_listing"
    t.boolean "is_default"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string "number"
    t.boolean "verified", default: false
    t.boolean "primary", default: false
    t.string "verification_code"
    t.datetime "code_expiry"
    t.integer "verification_attempts", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_phone_numbers_on_user_id"
  end

  create_table "user_packages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "package_id", null: false
    t.integer "listings_consumed"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_user_packages_on_package_id"
    t.index ["user_id"], name: "index_user_packages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.string "status"
    t.boolean "admin"
    t.string "provider"
    t.string "uid"
    t.boolean "phone_verified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "corporate_profiles", "users"
  add_foreign_key "phone_numbers", "users"
  add_foreign_key "user_packages", "packages"
  add_foreign_key "user_packages", "users"
end
