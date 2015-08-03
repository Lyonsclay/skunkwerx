# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150816025111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  create_table "carts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engines", force: true do |t|
    t.string  "engine"
    t.integer "model_id"
    t.integer "vehicle_id"
  end

  add_index "engines", ["model_id"], name: "index_engines_on_model_id", using: :btree
  add_index "engines", ["vehicle_id"], name: "index_engines_on_vehicle_id", using: :btree

  create_table "line_items", force: true do |t|
    t.integer  "item_id"
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",   default: 1
    t.integer  "order_id"
  end

  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
  add_index "line_items", ["item_id"], name: "index_line_items_on_item_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree

  create_table "makes", force: true do |t|
    t.string  "make"
    t.integer "vehicle_id"
  end

  add_index "makes", ["vehicle_id"], name: "index_makes_on_vehicle_id", using: :btree

  create_table "malone_tuning_builders", force: true do |t|
    t.text     "name"
    t.string   "engine"
    t.string   "power"
    t.string   "graph_url"
    t.text     "description"
    t.string   "unit_cost"
    t.string   "standalone_price"
    t.string   "price_with_purchase"
    t.string   "requires_urls",       default: [],    array: true
    t.string   "recommended_urls",    default: [],    array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "make"
    t.string   "model"
    t.boolean  "tune_created",        default: false
    t.boolean  "option_created",      default: false
  end

  create_table "malone_tunings", force: true do |t|
    t.string   "name",               limit: 50
    t.text     "description"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "item_id"
    t.decimal  "unit_cost",                     precision: 8, scale: 2, default: 0.0
    t.integer  "inventory"
    t.integer  "tax1_id"
    t.integer  "tax2_id"
    t.integer  "vehicle_id"
  end

  add_index "malone_tunings", ["vehicle_id"], name: "index_malone_tunings_on_vehicle_id", using: :btree

  create_table "models", force: true do |t|
    t.string  "model"
    t.integer "make_id"
    t.integer "vehicle_id"
  end

  add_index "models", ["make_id"], name: "index_models_on_make_id", using: :btree
  add_index "models", ["vehicle_id"], name: "index_models_on_vehicle_id", using: :btree

  create_table "options", force: true do |t|
    t.string   "name",               limit: 50
    t.text     "description"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "item_id"
    t.decimal  "unit_cost",                     precision: 8, scale: 2
    t.integer  "inventory"
    t.integer  "tax1_id"
    t.integer  "tax2_id"
    t.integer  "malone_tuning_id"
  end

  add_index "options", ["malone_tuning_id"], name: "index_options_on_malone_tuning_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.string   "payment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "item_id"
    t.decimal  "unit_cost",          precision: 8, scale: 2
    t.integer  "inventory"
    t.integer  "tax1_id"
    t.integer  "tax2_id"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "vehicles", force: true do |t|
    t.string  "name"
    t.integer "year_id"
  end

  add_index "vehicles", ["year_id"], name: "index_vehicles_on_year_id", using: :btree

  create_table "years", force: true do |t|
    t.string  "years",     default: [], array: true
    t.string  "range"
    t.integer "engine_id"
  end

end
