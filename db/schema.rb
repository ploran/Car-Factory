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

ActiveRecord::Schema.define(version: 20201023182239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assemblies", force: :cascade do |t|
    t.string "line"
    t.bigint "car_id"
    t.binary "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_assemblies_on_car_id"
  end

  create_table "car_computers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "car_models", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cars", force: :cascade do |t|
    t.bigint "car_model_id"
    t.integer "year"
    t.integer "wheels"
    t.string "chasis"
    t.string "laser"
    t.string "engine"
    t.decimal "price", precision: 8, scale: 2
    t.decimal "cost_price", precision: 8, scale: 2
    t.integer "seats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "car_computer_id"
    t.index ["car_computer_id"], name: "index_cars_on_car_computer_id"
    t.index ["car_model_id"], name: "index_cars_on_car_model_id"
  end

  create_table "defects", force: :cascade do |t|
    t.bigint "car_computer_id"
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_computer_id"], name: "index_defects_on_car_computer_id"
  end

  create_table "sale_orders", force: :cascade do |t|
    t.bigint "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_sale_orders_on_car_id"
  end

  add_foreign_key "cars", "car_computers"
  add_foreign_key "defects", "car_computers"
  add_foreign_key "sale_orders", "cars"
end
