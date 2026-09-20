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

ActiveRecord::Schema[8.0].define(version: 2026_09_19_154105) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "reports", force: :cascade do |t|
    t.bigint "new_user_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "status", default: 0, null: false
    t.string "error_message"
    t.integer "transaction_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_user_id", "created_at"], name: "index_reports_on_new_user_id_and_created_at"
    t.index ["new_user_id"], name: "index_reports_on_new_user_id"
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

  create_table "user_meta_data", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.datetime "born_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "balance_amounts", "new_users"
  add_foreign_key "budgets", "new_users"
  add_foreign_key "documents", "users"
  add_foreign_key "incomes", "new_users"
  add_foreign_key "reports", "new_users"
  add_foreign_key "transactions", "new_users"
end
