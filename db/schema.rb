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

ActiveRecord::Schema.define(version: 20130611041459) do

  create_table "compound_word_links", force: true do |t|
    t.integer  "compound_id"
    t.integer  "word_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "compound_word_links", ["compound_id", "word_id"], name: "compound_id", using: :btree
  add_index "compound_word_links", ["word_id", "compound_id"], name: "word_id", using: :btree

  create_table "extra_data", force: true do |t|
    t.text     "data"
    t.integer  "storable_id"
    t.string   "storable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extra_data", ["storable_type", "storable_id"], name: "index_extra_data_on_storable_type_and_storable_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "word_data", force: true do |t|
    t.integer  "word_id"
    t.string   "usage"
    t.string   "part_of_speech"
    t.integer  "stroke_count"
    t.string   "radical"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "word_data", ["word_id"], name: "index_word_data_on_word_id", using: :btree

  create_table "words", force: true do |t|
    t.string   "chars_trad"
    t.string   "chars_simp"
    t.string   "jyutping"
    t.string   "yale"
    t.string   "pinyin"
    t.text     "english"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "english_2"
    t.boolean  "single_char"
  end

end
