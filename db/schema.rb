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

ActiveRecord::Schema[7.1].define(version: 2024_06_11_150632) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "booking_prices", force: :cascade do |t|
    t.decimal "price", precision: 12, scale: 3
    t.datetime "created_at", null: false
    t.bigint "booking_id", null: false
    t.index ["booking_id"], name: "index_booking_prices_on_booking_id"
    t.index ["created_at"], name: "index_booking_prices_on_created_at", order: :desc
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "status", default: 0
    t.decimal "price", precision: 12, scale: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cancellation_requests", force: :cascade do |t|
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "booking_id", null: false
    t.index ["booking_id"], name: "index_cancellation_requests_on_booking_id"
  end

  create_table "modification_requests", force: :cascade do |t|
    t.integer "status", default: 0
    t.decimal "price", precision: 12, scale: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "booking_id", null: false
    t.index ["booking_id"], name: "index_modification_requests_on_booking_id"
  end

  add_foreign_key "booking_prices", "bookings"
  add_foreign_key "cancellation_requests", "bookings"
  add_foreign_key "modification_requests", "bookings"
end
