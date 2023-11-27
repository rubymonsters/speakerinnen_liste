# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_10_28_163837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_tokens", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "token"
  end

  create_table "blog_posts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position", default: 0
  end

  create_table "categories_tags", id: :serial, force: :cascade do |t|
    t.integer "category_id"
    t.integer "tag_id"
    t.index ["category_id", "tag_id"], name: "index_categories_tags_on_category_id_and_tag_id"
    t.index ["category_id"], name: "index_categories_tags_on_category_id"
    t.index ["tag_id"], name: "index_categories_tags_on_tag_id"
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["category_id"], name: "index_category_translations_on_category_id"
    t.index ["locale"], name: "index_category_translations_on_locale"
  end

  create_table "feature_profiles", force: :cascade do |t|
    t.bigint "feature_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_feature_profiles_on_feature_id"
    t.index ["profile_id"], name: "index_feature_profiles_on_profile_id"
  end

  create_table "feature_translations", force: :cascade do |t|
    t.bigint "feature_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.text "description"
    t.index ["feature_id"], name: "index_feature_translations_on_feature_id"
    t.index ["locale"], name: "index_feature_translations_on_locale"
  end

  create_table "features", force: :cascade do |t|
    t.integer "position"
    t.boolean "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "locale_languages", id: :serial, force: :cascade do |t|
    t.string "iso_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medialinks", id: :serial, force: :cascade do |t|
    t.integer "profile_id"
    t.text "url"
    t.text "title"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position"
    t.string "language"
    t.index ["profile_id"], name: "index_medialinks_on_profile_id"
  end

  create_table "profile_translations", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "main_topic"
    t.text "bio"
    t.string "twitter"
    t.string "website"
    t.string "city"
    t.string "website_2"
    t.string "website_3"
    t.string "profession"
    t.string "personal_note"
    t.index ["locale"], name: "index_profile_translations_on_locale"
    t.index ["profile_id"], name: "index_profile_translations_on_profile_id"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "picture"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin", default: false
    t.string "provider"
    t.string "uid"
    t.boolean "published", default: false
    t.text "admin_comment"
    t.string "slug"
    t.string "country"
    t.string "iso_languages"
    t.string "copyright"
    t.string "personal_note", limit: 175
    t.boolean "willing_to_travel"
    t.boolean "nonprofit"
    t.boolean "inactive", default: false
    t.string "state"
    t.index ["confirmation_token"], name: "index_profiles_on_confirmation_token", unique: true
    t.index ["email"], name: "index_profiles_on_email", unique: true
    t.index ["reset_password_token"], name: "index_profiles_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_profiles_on_slug", unique: true
  end

  create_table "profiles_services", id: false, force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "profile_id", null: false
    t.index ["service_id", "profile_id"], name: "index_profiles_services_on_service_id_and_profile_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tags_locale_languages", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "locale_language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "feature_profiles", "features"
  add_foreign_key "feature_profiles", "profiles"
end
