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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130324112924) do

  create_table "developers", :force => true do |t|
    t.integer  "gamer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "developers", ["gamer_id"], :name => "index_developers_on_gamer_id"

  create_table "gamers", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "keywords", :force => true do |t|
    t.string   "name"
    t.boolean  "is_english"
    t.boolean  "approved",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "projects", :force => true do |t|
    t.integer  "developer_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "projects", ["developer_id"], :name => "index_projects_on_developer_id"

  create_table "subscription_models", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "synonyms", :force => true do |t|
    t.string   "name"
    t.integer  "keyword_id"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "synonyms", ["keyword_id"], :name => "index_synonyms_on_keyword_id"

  create_table "votes", :force => true do |t|
    t.integer  "synonym_id"
    t.integer  "gamer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "votes", ["gamer_id"], :name => "index_votes_on_gamer_id"
  add_index "votes", ["synonym_id"], :name => "index_votes_on_synonym_id"

end
