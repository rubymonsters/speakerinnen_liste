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

ActiveRecord::Schema.define(version: 20170713124525) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_tokens", force: true do |t|
    t.string "name"
    t.string "token"
  end

  create_table "blog_posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_tags", force: true do |t|
    t.integer "category_id"
    t.integer "tag_id"
  end

  add_index "categories_tags", ["category_id", "tag_id"], name: "index_categories_tags_on_category_id_and_tag_id", using: :btree
  add_index "categories_tags", ["category_id"], name: "index_categories_tags_on_category_id", using: :btree
  add_index "categories_tags", ["tag_id"], name: "index_categories_tags_on_tag_id", using: :btree

  create_table "category_translations", force: true do |t|
    t.integer  "category_id"
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "medialinks", force: true do |t|
    t.integer  "profile_id"
    t.text     "url"
    t.text     "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position"
  end

  add_index "medialinks", ["profile_id"], name: "index_medialinks_on_profile_id", using: :btree

  create_table "profile_translations", force: true do |t|
    t.integer  "profile_id"
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "main_topic"
    t.text     "bio"
    t.string   "city"
    t.string   "twitter"
    t.string   "website"
  end

  add_index "profile_translations", ["locale"], name: "index_profile_translations_on_locale", using: :btree
  add_index "profile_translations", ["profile_id"], name: "index_profile_translations_on_profile_id", using: :btree

  create_table "profiles", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "languages"
    t.string   "city"
    t.string   "picture"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "talks"
    t.boolean  "admin",                  default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "media_url"
    t.boolean  "published",              default: false
    t.text     "admin_comment"
    t.string   "slug"
    t.string   "country"
    t.string   "iso_languages"
    t.string   "website"
  end

  add_index "profiles", ["confirmation_token"], name: "index_profiles_on_confirmation_token", unique: true, using: :btree
  add_index "profiles", ["email"], name: "index_profiles_on_email", unique: true, using: :btree
  add_index "profiles", ["reset_password_token"], name: "index_profiles_on_reset_password_token", unique: true, using: :btree
  add_index "profiles", ["slug"], name: "index_profiles_on_slug", unique: true, using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

end
