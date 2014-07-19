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

ActiveRecord::Schema.define(version: 20140715145841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

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
    t.string   "engine"
    t.string   "years",      array: true
    t.integer  "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "engines", ["model_id"], name: "index_engines_on_model_id", using: :btree

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
    t.string   "make"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "makes", ["make"], name: "index_makes_on_make", using: :btree

  create_table "malone_tunes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "item_id"
    t.decimal  "unit_cost",           precision: 8, scale: 2
    t.integer  "inventory"
    t.string   "folder"
    t.integer  "tax1_id"
    t.integer  "tax2_id"
    t.text     "requires"
    t.text     "recommended"
    t.string   "engine"
    t.string   "power"
    t.decimal  "price_with_purchase"
    t.decimal  "standalone_price"
  end

  create_table "models", force: true do |t|
    t.string   "model"
    t.integer  "make_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "models", ["make_id"], name: "index_models_on_make_id", using: :btree

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

end
