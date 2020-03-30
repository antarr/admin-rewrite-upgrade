ActiveRecord::Schema.define(:version => 20101216072412) do

  create_table "administrators", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", :force => true do |t|
    t.string   "username",   :limit => 32,  :default => "", :null => false
    t.string   "password",   :limit => 32,  :default => "", :null => false
    t.string   "email",      :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # add_index "admins", "username", unique: true, length: 191

  create_table "domains", :force => true do |t|
    t.string   "name",       :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quota"
    t.integer  "quotamax"
  end

  # add_index "domains", "name", unique: true, length: 191

  create_table "forwardings", :force => true do |t|
    t.integer  "domain_id",                  :default => 0,  :null => false
    t.string   "source",      :limit => 128, :default => "", :null => false
    t.text     "destination",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routings", :force => true do |t|
    t.string "destination", :limit => 128
    t.string "transport",   :limit => 128
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # add_index "sessions", "session_id", length: 191
  # add_index "sessions", "updated_at", length: 191

  create_table "userpref", :primary_key => "prefid", :force => true do |t|
    t.string "username",   :limit => 100, :default => "", :null => false
    t.string "preference", :limit => 50,  :default => "", :null => false
    t.string "value",      :limit => 100, :default => "", :null => false
  end

  # add_index "userpref", "username", length: 191

  create_table "users", :force => true do |t|
    t.integer  "domain_id"
    t.string   "email",      :limit => 128, :default => "", :null => false
    t.string   "name",       :limit => 128
    t.string   "fullname",   :limit => 128
    t.string   "password",   :limit => 32,  :default => "", :null => false
    t.string   "home",                      :default => "", :null => false
    t.integer  "priority",                  :default => 7,  :null => false
    t.integer  "policy_id",                 :default => 1,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quota"
  end

end
