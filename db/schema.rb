# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100123235800) do

  create_table "hashtags", :force => true do |t|
    t.string   "tag"
    t.boolean  "include",    :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "syntaxes", :force => true do |t|
    t.string   "format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "syntax_id"
    t.integer  "tweet_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "field"
  end

  create_table "tweets", :force => true do |t|
    t.string   "text",                    :null => false
    t.string   "from_user",               :null => false
    t.integer  "tweet_id"
    t.datetime "time_of_tweet"
    t.string   "to_user"
    t.string   "source"
    t.string   "profile_image_url"
    t.integer  "longitude_times_1000000"
    t.integer  "latitude_times_1000000"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
