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

ActiveRecord::Schema.define(version: 20171103204605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instruments", force: :cascade do |t|
    t.string   "value",              null: false
    t.string   "display_name",       null: false
    t.integer  "number_of_frets",    null: false
    t.integer  "number_of_strings",  null: false
    t.integer  "open_string_values", null: false, array: true
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string   "name",                                  null: false
    t.string   "letter",                                null: false
    t.boolean  "flat",                  default: false, null: false
    t.boolean  "sharp",                 default: false, null: false
    t.integer  "value"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "double_flat",           default: false
    t.boolean  "double_sharp",          default: false
    t.integer  "half_step_id"
    t.integer  "whole_step_id"
    t.integer  "minor_third_id"
    t.integer  "major_third_id"
    t.integer  "perfect_fourth_id"
    t.integer  "augmented_fourth_id"
    t.integer  "diminished_fifth_id"
    t.integer  "perfect_fifth_id"
    t.integer  "augmented_fifth_id"
    t.integer  "minor_sixth_id"
    t.integer  "major_sixth_id"
    t.integer  "diminished_seventh_id"
    t.integer  "minor_seventh_id"
    t.integer  "major_seventh_id"
    t.string   "display_name"
  end

end
