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

ActiveRecord::Schema.define(:version => 20101421171360) do

  create_table "keys", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.string   "description"
    t.string   "typecast",    :default => "String"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "node_contents", :force => true do |t|
    t.string  "name",          :limit => 100
    t.text    "content"
    t.integer "node_id"
    t.text    "draft_content"
    t.string  "teaser"
    t.string  "draft_teaser"
  end

  add_index "node_contents", ["node_id"], :name => "index_page_parts_on_page_id"

  create_table "nodes", :force => true do |t|
    t.string   "type",                 :limit => 16,  :default => "Page", :null => false
    t.string   "title"
    t.string   "url_alias"
    t.string   "ancestry"
    t.string   "slug",                 :limit => 100
    t.string   "breadcrumb",           :limit => 160
    t.integer  "status_id",                           :default => 1,      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "virtual",                             :default => false,  :null => false
    t.integer  "lock_version",                        :default => 0
    t.string   "description"
    t.string   "keywords"
    t.string   "author"
    t.integer  "position",                            :default => 0
    t.boolean  "show_on_menu",                        :default => true
    t.string   "redirect_to"
    t.string   "browser_title"
    t.string   "menu_title"
    t.boolean  "skip_page"
    t.boolean  "is_root",                             :default => false
    t.boolean  "show_on_site_map",                    :default => false
    t.integer  "show_menu_on_sidebar",                :default => 0
    t.boolean  "show_menu_expanded",                  :default => false
    t.integer  "webform_id"
    t.boolean  "skip_top_level_page",                 :default => false
    t.boolean  "has_children",                        :default => false
    t.integer  "photos_count",                        :default => 0
  end

  add_index "nodes", ["ancestry"], :name => "index_pages_on_ancestry"
  add_index "nodes", ["type"], :name => "index_nodes_on_type"
  add_index "nodes", ["url_alias"], :name => "index_pages_on_slug"

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.boolean "locked",      :default => false
    t.text    "permissions"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id"

  create_table "snippets", :force => true do |t|
    t.string   "name",          :limit => 100, :default => "", :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "lock_version",                 :default => 0
  end

  add_index "snippets", ["name"], :name => "name", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer "taxonomy_id"
    t.string  "taggable_type"
    t.integer "taggable_id"
  end

  add_index "taggings", ["taggable_type", "taggable_id"], :name => "index_taggings_on_taggable_type_and_taggable_id"
  add_index "taggings", ["taxonomy_id"], :name => "index_taggings_on_taxonomy_id"

  create_table "taxonomies", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blog_posts_count", :default => 0
  end

  add_index "taxonomies", ["ancestry"], :name => "index_taxonomies_on_ancestry"
  add_index "taxonomies", ["name"], :name => "index_taxonomies_on_name"

  create_table "uploaded_files", :force => true do |t|
    t.string  "type"
    t.string  "name"
    t.string  "file_file_name"
    t.string  "file_content_type"
    t.string  "file_file_size"
    t.integer "node_id"
    t.string  "category"
    t.string  "caption"
    t.integer "position"
    t.integer "downloads_count",   :default => 0
  end

  add_index "uploaded_files", ["node_id"], :name => "index_photos_on_page_id"

  create_table "users", :force => true do |t|
    t.string   "login",                               :default => "", :null => false
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",        :limit => 128, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_sign_in_at"
    t.integer  "sign_in_count",                       :default => 0,  :null => false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authenticaton_token"
    t.string   "single_access_token"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "webforms", :force => true do |t|
    t.string   "type",           :default => "Webform", :null => false
    t.string   "name",                                  :null => false
    t.boolean  "show_name",      :default => true
    t.string   "instructions"
    t.string   "template",                              :null => false
    t.string   "send_to_email"
    t.string   "email_subject"
    t.text     "email_template"
    t.integer  "document_id"
    t.string   "thanks_path"
    t.string   "thanks_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  add_index :nodes, [:url_alias, :show_on_site_map]
  add_index :roles, :name
  
  create_table :activities do |t|
    t.column :user_id, :integer, :limit => 10
    t.column :action, :string, :limit => 50
    t.column :item_id, :integer, :limit => 10
    t.column :item_type, :string
    t.column :created_at, :datetime
  end

  add_index :activities, :user_id
  

end
