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

ActiveRecord::Schema.define(version: 20160801133437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "imports", force: :cascade do |t|
    t.integer  "time_from"
    t.integer  "time_to"
    t.jsonb    "data",       default: {}, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "digest"
  end

  add_index "imports", ["data"], name: "index_imports_on_data", using: :gin

  create_table "modifications", force: :cascade do |t|
    t.text     "data",       default: "--- []\n"
    t.integer  "tender_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "modifications", ["tender_id"], name: "index_modifications_on_tender_id", using: :btree

  create_table "tenders", force: :cascade do |t|
    t.jsonb    "data",       default: {}, null: false
    t.string   "digest"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "tenders", ["data"], name: "index_tenders_on_data", using: :gin

  add_foreign_key "modifications", "tenders"
end
