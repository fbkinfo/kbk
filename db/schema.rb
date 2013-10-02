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

ActiveRecord::Schema.define(version: 20130930061354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_attachements", force: true do |t|
    t.string   "file",        null: false
    t.integer  "document_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_attachements", ["document_id"], name: "index_document_attachements_on_document_id", using: :btree

  create_table "documents", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "kind"
    t.date     "document_date"
    t.date     "due_date"
    t.integer  "organization_id"
    t.integer  "investigation_id"
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "ancestry"
    t.integer  "response_id"
    t.string   "pdf"
    t.integer  "author_id"
    t.boolean  "final",            default: false, null: false
    t.datetime "deleted_at"
  end

  add_index "documents", ["ancestry"], name: "index_documents_on_ancestry", using: :btree
  add_index "documents", ["final"], name: "index_documents_on_final", using: :btree
  add_index "documents", ["investigation_id"], name: "index_documents_on_investigation_id", using: :btree
  add_index "documents", ["kind", "document_date"], name: "index_documents_on_kind_and_document_date", using: :btree
  add_index "documents", ["kind", "due_date"], name: "index_documents_on_kind_and_due_date", using: :btree
  add_index "documents", ["organization_id"], name: "index_documents_on_organization_id", using: :btree
  add_index "documents", ["response_id"], name: "index_documents_on_response_id", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "favourites", force: true do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.string   "entry_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investigations", force: true do |t|
    t.string   "title",              null: false
    t.text     "description"
    t.string   "status",             null: false
    t.integer  "latest_document_id"
    t.integer  "user_id"
    t.date     "closed_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "project_kind",       null: false
    t.datetime "deleted_at"
    t.date     "published_until"
  end

  add_index "investigations", ["project_kind"], name: "index_investigations_on_project_kind", using: :btree
  add_index "investigations", ["title"], name: "index_investigations_on_title", unique: true, using: :btree

  create_table "links", force: true do |t|
    t.string   "title",            null: false
    t.text     "comment"
    t.string   "url",              null: false
    t.string   "icon"
    t.integer  "investigation_id", null: false
    t.date     "entry_date",       null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "links", ["investigation_id"], name: "index_links_on_investigation_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.integer  "documents_count",      default: 0
    t.integer  "investigations_count", default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree

  create_table "photos", force: true do |t|
    t.string   "image",            null: false
    t.text     "comment"
    t.integer  "investigation_id"
    t.date     "entry_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "photos", ["investigation_id"], name: "index_photos_on_investigation_id", using: :btree

  create_table "snapshots", force: true do |t|
    t.integer  "document_id"
    t.string   "original_scan"
    t.string   "public_scan"
    t.integer  "number"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "original_scan_width"
    t.integer  "original_scan_height"
    t.integer  "public_scan_width"
    t.integer  "public_scan_height"
  end

  add_index "snapshots", ["document_id"], name: "index_snapshots_on_document_id", using: :btree

  create_table "timeline_entries", force: true do |t|
    t.string   "resource_type",    null: false
    t.integer  "resource_id",      null: false
    t.integer  "investigation_id", null: false
    t.date     "entry_date",       null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "timeline_entries", ["investigation_id"], name: "index_timeline_entries_on_investigation_id", using: :btree
  add_index "timeline_entries", ["resource_type", "resource_id"], name: "index_timeline_entries_on_resource_type_and_resource_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "documents_count",        default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.string   "role",                                   null: false
    t.boolean  "blocked",                default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.text     "body",             null: false
    t.integer  "investigation_id", null: false
    t.date     "entry_date",       null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "videos", ["investigation_id"], name: "index_videos_on_investigation_id", using: :btree

end
