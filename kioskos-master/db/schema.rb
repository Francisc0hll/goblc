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

ActiveRecord::Schema.define(version: 20171227174548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
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
    t.string   "admin_type"
    t.integer  "institution_id"
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["institution_id"], name: "index_admin_users_on_institution_id", using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "api_authentications", force: :cascade do |t|
    t.string   "token"
    t.integer  "expires_in"
    t.string   "token_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authentications", force: :cascade do |t|
    t.string   "auth_type"
    t.string   "minucia"
    t.integer  "finger"
    t.string   "signature"
    t.integer  "user_id"
    t.datetime "created_at"
    t.integer  "totem_id"
    t.index ["totem_id"], name: "index_authentications_on_totem_id", using: :btree
    t.index ["user_id"], name: "index_authentications_on_user_id", using: :btree
  end

  create_table "certificates", force: :cascade do |t|
    t.integer  "procedure_id"
    t.string   "rut"
    t.string   "email"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "status",       default: "requested"
    t.string   "totem_id"
    t.index ["procedure_id"], name: "index_certificates_on_procedure_id", using: :btree
  end

  create_table "clave_unica_petitions", force: :cascade do |t|
    t.string   "rut"
    t.string   "status",     default: "requested"
    t.string   "method"
    t.string   "phone"
    t.string   "email"
    t.integer  "totem_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["totem_id"], name: "index_clave_unica_petitions_on_totem_id", using: :btree
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_on_card_transactions", force: :cascade do |t|
    t.json     "event_json"
    t.integer  "totem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["totem_id"], name: "index_match_on_card_transactions_on_totem_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.text     "message"
    t.string   "chile_atiende_id"
    t.string   "rut"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "read",             default: false
  end

  create_table "procedure_logs", force: :cascade do |t|
    t.string   "name"
    t.integer  "chileatiende_id"
    t.integer  "totem_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["totem_id"], name: "index_procedure_logs_on_totem_id", using: :btree
  end

  create_table "procedures", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",             precision: 10, scale: 2
    t.boolean  "active_in_totem",                            default: false
    t.string   "security"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "type_of_procedure"
    t.text     "description"
    t.string   "info"
    t.string   "warning"
    t.integer  "request_count",                              default: 0
    t.integer  "delivery_count",                             default: 0
    t.integer  "id_proceso_simple"
    t.integer  "id_etapa_simple"
    t.string   "class_name_simple"
    t.integer  "chile_atiende_id"
    t.integer  "institution_id"
    t.string   "category"
    t.string   "subcategory"
    t.index ["institution_id"], name: "index_procedures_on_institution_id", using: :btree
  end

  create_table "search_procedure_logs", force: :cascade do |t|
    t.string   "search"
    t.boolean  "found"
    t.text     "results"
    t.integer  "totem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["totem_id"], name: "index_search_procedure_logs_on_totem_id", using: :btree
  end

  create_table "totem_monitors", force: :cascade do |t|
    t.string   "totem_tid",  null: false
    t.datetime "ping_time",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "totems", force: :cascade do |t|
    t.string   "tid",                                null: false
    t.boolean  "active",             default: false, null: false
    t.string   "location"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "country_phone_code"
    t.string   "location_type"
    t.string   "rut",                default: "0",   null: false
    t.string   "password_digest"
    t.integer  "institution_id"
    t.boolean  "has_printer",        default: true
    t.index ["institution_id"], name: "index_totems_on_institution_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "rut",                              null: false
    t.integer  "sign_in_count",      default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "current_totem_id"
    t.integer  "last_totem_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "name",               default: "f"
    t.string   "email",              default: "f"
    t.string   "last_name_father"
    t.string   "last_name_mother"
    t.index ["current_totem_id"], name: "index_users_on_current_totem_id", using: :btree
    t.index ["last_totem_id"], name: "index_users_on_last_totem_id", using: :btree
    t.index ["rut"], name: "index_users_on_rut", unique: true, using: :btree
  end

  add_foreign_key "admin_users", "institutions"
  add_foreign_key "procedure_logs", "totems"
  add_foreign_key "procedures", "institutions"
  add_foreign_key "totems", "institutions"
end
