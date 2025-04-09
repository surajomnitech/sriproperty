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

ActiveRecord::Schema[7.1].define(version: 2025_04_09_112924) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  create_table "listing_cycles", force: :cascade do |t|
    t.bigint "user_package_purchase_id", null: false
    t.datetime "cycle_start_date", null: false
    t.datetime "cycle_end_date", null: false
    t.integer "free_listings_used", default: 0
    t.integer "paid_listings_used", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_package_purchase_id", "cycle_start_date"], name: "idx_on_user_package_purchase_id_cycle_start_date_abf287ec5b"
    t.index ["user_package_purchase_id"], name: "index_listing_cycles_on_user_package_purchase_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.integer "free_listings_count"
    t.integer "max_photos_per_listing"
    t.boolean "is_default"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration_days", default: 30, null: false
    t.integer "free_listings_per_cycle", default: 0, null: false
    t.integer "max_paid_listings", default: 1, null: false
    t.integer "listing_duration_days", default: 60, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.boolean "invoice_required", default: false
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

  create_table "user_package_purchases", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "package_id", null: false
    t.integer "units", default: 1, null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.decimal "total_amount", precision: 10, scale: 2
    t.integer "payment_status", default: 0
    t.string "invoice_number"
    t.string "payment_reference"
    t.datetime "payment_date"
    t.text "admin_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_user_package_purchases_on_package_id"
    t.index ["user_id"], name: "index_user_package_purchases_on_user_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "corporate_profiles", "users"
  add_foreign_key "listing_cycles", "user_package_purchases"
  add_foreign_key "phone_numbers", "users"
  add_foreign_key "user_package_purchases", "packages"
  add_foreign_key "user_package_purchases", "users"
  add_foreign_key "user_packages", "packages"
  add_foreign_key "user_packages", "users"
end
