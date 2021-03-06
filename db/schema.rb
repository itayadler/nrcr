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

ActiveRecord::Schema.define(version: 20141129211523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_scores", force: true do |t|
    t.string "source_card_code"
    t.string "dest_card_code"
    t.float  "score"
  end

  create_table "cards", force: true do |t|
    t.string "code"
    t.string "side"
    t.string "card_type"
    t.string "title"
    t.string "description"
    t.string "nrdb_url"
    t.string "image_url"
  end

  add_index "cards", ["code"], name: "index_cards_on_code", using: :btree

  create_table "deck_cards", force: true do |t|
    t.string  "card_code"
    t.integer "deck_id"
  end

  create_table "decks", force: true do |t|
    t.integer  "nrdb_id"
    t.text     "name"
    t.datetime "creation_date"
    t.text     "description"
    t.string   "username"
  end

end
