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

ActiveRecord::Schema.define(version: 20140220134139) do

  create_table "todos", force: true do |t|
    t.string   "title",      null: false
    t.string   "content"
    t.integer  "user_id",    null: false
    t.integer  "type_id"
    t.integer  "context_id"
    t.integer  "project_id"
    t.datetime "expire"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "todos", ["user_id", "context_id"], name: "index_todos_on_user_id_and_context_id"
  add_index "todos", ["user_id", "project_id"], name: "index_todos_on_user_id_and_project_id"
  add_index "todos", ["user_id", "type_id"], name: "index_todos_on_user_id_and_type_id"
  add_index "todos", ["user_id"], name: "index_todos_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
