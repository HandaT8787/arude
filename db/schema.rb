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

ActiveRecord::Schema[8.0].define(version: 2026_09_11_094503) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_bookmarks_on_post_id"
    t.index ["user_id", "post_id"], name: "index_bookmarks_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id", null: false
    t.text "body", null: false
    t.boolean "is_checked", default: false, null: false
    t.datetime "checked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.string "role", default: "member", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_tags", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "tag_id"], name: "index_post_tags_on_post_id_and_tag_id", unique: true
    t.index ["post_id"], name: "index_post_tags_on_post_id"
    t.index ["tag_id"], name: "index_post_tags_on_tag_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.string "title", null: false
    t.text "description"
    t.string "category"
    t.string "congestion"
    t.integer "price"
    t.text "caution"
    t.float "latitude"
    t.float "longitude"
    t.string "prefecture"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "local_years_at_post"
    t.index ["group_id"], name: "index_posts_on_group_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "visit_id", null: false
    t.string "category", null: false
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visit_id"], name: "index_ratings_on_visit_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "comment_id", null: false
    t.text "reason", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_reports_on_comment_id"
    t.index ["user_id", "comment_id"], name: "index_reports_on_user_id_and_comment_id", unique: true
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "residences", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "prefecture", null: false
    t.string "city", null: false
    t.date "started_on", null: false
    t.date "ended_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["user_id"], name: "index_residences_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "tag_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "username", default: "", null: false
    t.text "bio"
    t.boolean "is_admin", default: false, null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id", null: false
    t.text "impression"
    t.datetime "visited_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_visits_on_post_id"
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "posts"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "groups"
  add_foreign_key "posts", "users"
  add_foreign_key "ratings", "visits"
  add_foreign_key "reports", "comments"
  add_foreign_key "reports", "users"
  add_foreign_key "residences", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "visits", "posts"
  add_foreign_key "visits", "users"
end
