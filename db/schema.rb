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

ActiveRecord::Schema[8.0].define(version: 2025_03_08_155720) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "balance_amounts", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "new_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_user_id"], name: "index_balance_amounts_on_new_user_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.bigint "new_user_id", null: false
    t.integer "amount"
    t.integer "budget_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_user_id"], name: "index_budgets_on_new_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.integer "income_category"
    t.bigint "new_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_user_id"], name: "index_incomes_on_new_user_id"
  end

  create_table "new_users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_category"
    t.string "description"
    t.integer "amount"
    t.bigint "new_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_user_id"], name: "index_transactions_on_new_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "balance_amounts", "new_users"
  add_foreign_key "budgets", "new_users"
  add_foreign_key "documents", "users"
  add_foreign_key "incomes", "new_users"
  add_foreign_key "transactions", "new_users"
end
