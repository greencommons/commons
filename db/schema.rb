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

ActiveRecord::Schema.define(version: 20170605141931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", id: false, force: :cascade do |t|
    t.string   "label"
    t.string   "access_key"
    t.string   "secret_key"
    t.integer  "user_id"
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["access_key"], name: "index_api_keys_on_access_key", using: :btree
    t.index ["user_id"], name: "index_api_keys_on_user_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",                           null: false
    t.string   "short_description"
    t.text     "long_description"
    t.string   "url"
    t.string   "email"
    t.json     "metadata"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "cached_tags",       default: [],              array: true
    t.datetime "published_at"
  end

  create_table "groups_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "admin",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_groups_users_on_user_id", using: :btree
  end

  create_table "lists", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "description"
    t.string   "owner_type",                null: false
    t.integer  "owner_id",                  null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "cached_tags",  default: [],              array: true
    t.datetime "published_at"
    t.integer  "privacy",      default: 1,  null: false
    t.index ["owner_type", "owner_id"], name: "index_lists_on_owner_type_and_owner_id", using: :btree
  end

  create_table "lists_items", force: :cascade do |t|
    t.integer  "list_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.text     "note"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "published_at"
    t.index ["item_type", "item_id"], name: "index_lists_items_on_item_type_and_item_id", using: :btree
    t.index ["list_id", "item_id", "item_type"], name: "index_lists_items_on_list_id_and_item_id_and_item_type", unique: true, using: :btree
    t.index ["list_id"], name: "index_lists_items_on_list_id", using: :btree
  end

  create_table "resources", force: :cascade do |t|
    t.string   "title",                      null: false
    t.integer  "resource_type", default: 0,  null: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.jsonb    "metadata",      default: {}, null: false
    t.jsonb    "content",       default: {}, null: false
    t.text     "cached_tags",   default: [],              array: true
    t.integer  "privacy",       default: 0,  null: false
    t.string   "url"
    t.datetime "published_at"
    t.index ["user_id"], name: "index_resources_on_user_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

end
