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

ActiveRecord::Schema.define(version: 20151025174509) do

  create_table "checks", force: :cascade do |t|
    t.string   "github_user"
    t.string   "repo"
    t.string   "sha"
    t.boolean  "passed"
    t.integer  "lint_id"
    t.integer  "review_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "checks", ["lint_id"], name: "index_checks_on_lint_id"
  add_index "checks", ["review_id"], name: "index_checks_on_review_id"

  create_table "lints", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "github_user"
    t.string   "repo"
  end

end
