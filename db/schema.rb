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

ActiveRecord::Schema.define(:version => 20100513080813) do

  create_table "suggested_users", :force => true do |t|
    t.string   "screen_name",       :limit => 32,  :null => false
    t.string   "name",              :limit => 32
    t.string   "profile_image_url", :limit => 128
    t.integer  "followers_count"
    t.string   "description",       :limit => 256
    t.string   "category",          :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suggested_users", ["screen_name"], :name => "index_suggested_users_on_screen_name"

end
