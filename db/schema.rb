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

ActiveRecord::Schema.define(version: 20161222092424) do

  create_table "authentications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "provider",      limit: 191
    t.string   "uid",           limit: 191
    t.integer  "user_id"
    t.text     "info",          limit: 65535
    t.text     "extra",         limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "refresh_token", limit: 191
  end

  create_table "catalogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name",                    limit: 191
    t.string   "slug",                    limit: 191
    t.string   "type",                    limit: 191
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "user_id"
    t.integer  "categories_count",                      default: 0
    t.string   "sketch",                  limit: 191
    t.integer  "status",                                default: 0
    t.text     "footnote",                limit: 65535
    t.integer  "online_categories_count",               default: 0
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name",                  limit: 191
    t.string   "slug",                  limit: 191
    t.integer  "catalog_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "user_id"
    t.integer  "projects_count",                    default: 0
    t.integer  "online_projects_count",             default: 0, null: false
    t.integer  "status",                            default: 0
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.text     "content",          limit: 65535
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 191
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "developers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name",              limit: 191
    t.string   "avatar",            limit: 191
    t.integer  "github_id"
    t.integer  "public_repos"
    t.integer  "subscribers_count"
    t.integer  "watchers_count"
    t.integer  "forks_count"
    t.integer  "identity",                      default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "episodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "human_id"
    t.string   "project_list", limit: 191
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "status",                   default: 0
  end

  create_table "gem_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.decimal  "total_downloads",               precision: 10
    t.integer  "releases"
    t.string   "current_version", limit: 191
    t.datetime "released"
    t.datetime "first_release"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "others",          limit: 65535
  end

  create_table "github_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.integer  "subscribers_count"
    t.integer  "watchers_count"
    t.integer  "forks_count"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "others",            limit: 65535
    t.text     "readme",            limit: 65535
  end

  create_table "package_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.decimal  "total_downloads",               precision: 10
    t.integer  "releases"
    t.string   "current_version", limit: 191
    t.datetime "released"
    t.datetime "first_release"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "others",          limit: 65535
  end

  create_table "pod_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.decimal  "total_downloads",               precision: 10
    t.integer  "releases"
    t.string   "current_version", limit: 191
    t.datetime "released"
    t.datetime "first_release"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "others",          limit: 65535
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name",            limit: 191
    t.text     "description",     limit: 65535
    t.string   "website",         limit: 191
    t.string   "wiki",            limit: 191
    t.string   "source_code",     limit: 191
    t.integer  "category_id"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.integer  "identity",                                               default: 0
    t.text     "author",          limit: 65535
    t.integer  "status",                                                 default: 0
    t.decimal  "popularity",                    precision: 15, scale: 2
    t.integer  "developer_id"
    t.boolean  "today_recommend"
    t.datetime "recommend_at"
    t.string   "human_name",      limit: 191
    t.string   "given_name",      limit: 191
  end

  create_table "user_recommend_projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_star_projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "email",                  limit: 191
    t.string   "encrypted_password",     limit: 191
    t.string   "reset_password_token",   limit: 191
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 191
    t.string   "last_sign_in_ip",        limit: 191
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "name",                   limit: 191
    t.boolean  "is_admin",                           default: false
    t.string   "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
