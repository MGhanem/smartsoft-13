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

ActiveRecord::Schema.define(:version => 20130326130524) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories_keywords", :force => true do |t|
    t.integer "category_id"
    t.integer "keyword_id"
  end

  create_table "developers", :force => true do |t|
    t.integer  "gamer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "developers", ["gamer_id"], :name => "index_developers_on_gamer_id"

  create_table "follows", :force => true do |t|
    t.integer  "developer_id"
    t.integer  "keyword_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "gamers", :force => true do |t|
    t.string   "username"
    t.integer  "age"
    t.string   "country"
    t.string   "education_level"
    t.integer  "highest_score"
    t.integer  "sign_up_status"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "gamers", ["email"], :name => "index_gamers_on_email", :unique => true
  add_index "gamers", ["reset_password_token"], :name => "index_gamers_on_reset_password_token", :unique => true

  create_table "keywords", :force => true do |t|
    t.string   "name"
    t.boolean  "is_english"
    t.boolean  "approved",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "my_subscriptions", :force => true do |t|
    t.integer  "word_search"
    t.integer  "word_follow"
    t.integer  "word_add"
    t.integer  "developer_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.boolean  "formal"
    t.integer  "minAge"
    t.integer  "maxAge"
    t.integer  "developer_id"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "projects", ["category_id"], :name => "index_projects_on_category_id"

  create_table "projects_categories", :force => true do |t|
    t.integer "categories_id"
    t.integer "projects_id"
  end

  create_table "searches", :force => true do |t|
    t.integer  "developer_id"
    t.integer  "synonym_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "subscription_models", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "limit"
  end

  create_table "synonyms", :force => true do |t|
    t.string   "name"
    t.integer  "keyword_id"
    t.boolean  "approved",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
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
