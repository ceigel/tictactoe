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

ActiveRecord::Schema.define(version: 20151127152116) do

  create_table "games", force: :cascade do |t|
    t.string   "player1"
    t.string   "player2"
    t.integer  "score_player1", default: 0
    t.integer  "score_player2", default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "play_count",    default: 0
  end

  add_index "games", ["player1"], name: "index_games_on_player1"
  add_index "games", ["player2"], name: "index_games_on_player2"

  create_table "rounds", force: :cascade do |t|
    t.string   "board_state",    limit: 9, default: "_________"
    t.integer  "game_id"
    t.integer  "current_player",           default: 1
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "rounds", ["game_id"], name: "index_rounds_on_game_id"

end
