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

ActiveRecord::Schema.define(version: 2022_12_20_154810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addreses", force: :cascade do |t|
    t.string "address", null: false
    t.string "district", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address", "district", "city"], name: "index_addreses_on_address_and_district_and_city", unique: true
    t.index ["address"], name: "index_addreses_on_address"
    t.index ["city"], name: "index_addreses_on_city"
    t.index ["district"], name: "index_addreses_on_district"
    t.index ["zip"], name: "index_addreses_on_zip", unique: true
  end

  create_table "address_assignments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "address_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id", "user_id"], name: "index_address_assignments_on_address_id_and_user_id", unique: true
    t.index ["address_id"], name: "index_address_assignments_on_address_id"
    t.index ["user_id"], name: "index_address_assignments_on_user_id"
  end

  create_table "albums", force: :cascade do |t|
    t.integer "artist_id", null: false
    t.string "name", null: false
    t.integer "year", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_albums_on_name"
  end

  create_table "loans", force: :cascade do |t|
    t.integer "rate", null: false
    t.bigint "pv", null: false
    t.integer "nper", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_loans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "loans", "users"
end
