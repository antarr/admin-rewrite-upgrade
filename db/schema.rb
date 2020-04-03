ActiveRecord::Schema.define(:version => 20101216072412) do

  # administrators for domains
  create_table "administrators", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # admins to connect to the app
  create_table "admins", :force => true do |t|
    t.string   "username",   :limit => 32,  :default => "", :null => false
    t.string   "password",   :limit => 32,  :default => "", :null => false
    t.string   "email",      :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", :force => true do |t|
    t.string   "name",       :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quota"
    t.integer  "quotamax"
  end

  create_table "forwardings", :force => true do |t|
    t.integer  "domain_id",                  :default => 0,  :null => false
    t.string   "source",      :limit => 128, :default => "", :null => false
    t.text     "destination",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userpref", :primary_key => "prefid", :force => true do |t|
    t.string "username",   :limit => 100, :default => "", :null => false
    t.string "preference", :limit => 50,  :default => "", :null => false
    t.string "value",      :limit => 100, :default => "", :null => false
  end

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
