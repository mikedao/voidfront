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

ActiveRecord::Schema[7.1].define(version: 2025_05_18_141932) do
  create_table "empires", force: :cascade do |t|
    t.string "name"
    t.integer "credits", default: 1000
    t.integer "minerals", default: 500
    t.integer "energy", default: 500
    t.integer "food", default: 500
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tax_rate", default: 20
    t.index ["user_id"], name: "index_empires_on_user_id", unique: true
  end

  create_table "star_systems", force: :cascade do |t|
    t.string "name"
    t.string "system_type"
    t.integer "max_population"
    t.integer "current_population", default: 10
    t.integer "max_buildings"
    t.integer "loyalty", default: 100
    t.integer "empire_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["empire_id"], name: "index_star_systems_on_empire_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.boolean "admin"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "empires", "users"
  add_foreign_key "star_systems", "empires"
end
