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

ActiveRecord::Schema.define(version: 20170409082851) do

  create_table "agreement_articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "article_id"], name: "index_agreement_articles_on_user_id_and_article_id", using: :btree
  end

  create_table "articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "title"
    t.text     "description",              limit: 65535
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "user_id"
    t.integer  "view_times",                             default: 0
    t.integer  "comments_count",                         default: 0
    t.string   "slug"
    t.boolean  "can_reprinted",                          default: true
    t.integer  "agreement_articles_count",               default: 0,    null: false
    t.integer  "status",                                 default: 0,    null: false
    t.index ["user_id"], name: "index_articles_on_user_id", using: :btree
  end

  create_table "asset_allocations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.date     "record_at"
    t.decimal  "stock_ratio", precision: 15, scale: 4
    t.decimal  "bond_ratio",  precision: 15, scale: 4
    t.decimal  "cash_ratio",  precision: 15, scale: 4
    t.decimal  "net_asset",   precision: 15, scale: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "origin",                               default: 0, null: false
    t.index ["project_id", "record_at"], name: "index_asset_allocations_on_project_id_and_record_at", using: :btree
    t.index ["project_id"], name: "index_asset_allocations_on_project_id", using: :btree
  end

  create_table "authentications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.text     "info",          limit: 65535
    t.text     "extra",         limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "refresh_token"
    t.text     "credentials",   limit: 65535
  end

  create_table "catalog_developers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "catalog_id"
    t.integer  "developer_id"
    t.string   "eastmoney_url"
    t.string   "sina_url"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "catalog_code"
    t.string   "developer_eastmoney_code"
    t.string   "developer_sina_code"
    t.integer  "status",                   default: 0
    t.index ["catalog_id", "developer_id"], name: "index_catalog_developers_on_catalog_id_and_developer_id", using: :btree
  end

  create_table "catalog_eastmoney_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "catalog_id"
    t.string   "catalog_code"
    t.text     "header_info",  limit: 65535
    t.text     "body_info",    limit: 65535
    t.text     "table_info",   limit: 65535
    t.text     "other_info",   limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "catalog_sina_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "catalog_id"
    t.string   "catalog_sina_code"
    t.text     "header_info",       limit: 65535
    t.text     "body_info",         limit: 65535
    t.text     "table_info",        limit: 65535
    t.text     "other_info",        limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "catalogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "type"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "user_id"
    t.integer  "categories_count",                      default: 0
    t.string   "sketch"
    t.integer  "status",                                default: 0
    t.text     "footnote",                limit: 65535
    t.integer  "online_categories_count",               default: 0
    t.integer  "initial",                               default: 0
    t.string   "short_name"
    t.string   "founder"
    t.date     "set_up_at"
    t.string   "scale"
    t.date     "scale_record_at"
    t.string   "code"
    t.text     "raw_show_html",           limit: 65535
    t.integer  "projects_count",                        default: 0, null: false
    t.string   "sina_code"
    t.string   "cover"
    t.text     "description",             limit: 65535
    t.index ["sina_code"], name: "index_catalogs_on_sina_code", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "catalog_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "user_id"
    t.integer  "projects_count",        default: 0
    t.integer  "online_projects_count", default: 0, null: false
    t.integer  "status",                default: 0
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.text     "content",          limit: 65535
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "floor"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
  end

  create_table "developer_projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "developer_id"
    t.integer  "project_id"
    t.date     "beginning_work_date"
    t.date     "end_of_work_date"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.string   "developer_eastmoney_code"
    t.string   "developer_sina_code"
    t.string   "project_code"
    t.string   "term_of_office"
    t.decimal  "as_return",                precision: 15, scale: 4
    t.integer  "status",                                            default: 0
    t.index ["developer_id", "project_id"], name: "index_developer_projects_on_developer_id_and_project_id", using: :btree
  end

  create_table "developers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.string   "avatar"
    t.integer  "github_id"
    t.integer  "public_repos"
    t.integer  "subscribers_count"
    t.integer  "watchers_count"
    t.integer  "forks_count"
    t.integer  "identity",                        default: 0
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "eastmoney_url"
    t.date     "take_office_date"
    t.text     "description",       limit: 65535
    t.integer  "age",                             default: 0
    t.string   "degree"
    t.string   "eastmoney_code"
    t.string   "sina_code"
    t.date     "rh_at"
    t.integer  "catalog_id"
    t.integer  "status",                          default: 0
    t.string   "slug"
    t.index ["eastmoney_code"], name: "index_developers_on_eastmoney_code", using: :btree
    t.index ["sina_code"], name: "index_developers_on_sina_code", using: :btree
  end

  create_table "episodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "human_id"
    t.string   "project_list"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "status",       default: 0
    t.datetime "recommend_at"
  end

  create_table "fund_chai_fens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.date     "break_convert_at"
    t.string   "break_type"
    t.string   "break_ratio"
    t.integer  "project_id"
    t.integer  "net_worth_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.date     "the_real_break_convert_at"
  end

  create_table "fund_fen_hongs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.date     "register_at"
    t.date     "ex_dividend_at"
    t.string   "bonus_per"
    t.date     "dividend_distribution_at"
    t.integer  "project_id"
    t.integer  "net_worth_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.decimal  "bonus",                    precision: 15, scale: 4
    t.date     "the_real_ex_dividend_at"
  end

  create_table "fund_jbgks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "full_name"
    t.string   "short_name"
    t.string   "code"
    t.string   "mold"
    t.string   "set_up_at"
    t.string   "build_at_and_scale"
    t.string   "assets_scale"
    t.string   "portion_scale"
    t.text     "benchmark",          limit: 65535
    t.text     "dividend_policy",    limit: 16777215
    t.text     "risk_yield",         limit: 65535
    t.text     "others",             limit: 16777215
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "project_id"
    t.index ["project_id"], name: "index_fund_jbgks_on_project_id", using: :btree
  end

  create_table "fund_raises", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.date     "beginning_at"
    t.date     "endding_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "fund_rankings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.string   "code"
    t.string   "name"
    t.decimal  "dwjz",                                  precision: 15, scale: 4
    t.integer  "three_year_rating",                                              default: 0
    t.integer  "five_year_rating",                                               default: 0
    t.decimal  "last_week_total_return",                precision: 15, scale: 4
    t.integer  "last_week_ranking"
    t.decimal  "last_month_total_return",               precision: 15, scale: 4
    t.integer  "last_month_ranking"
    t.decimal  "last_three_month_total_return",         precision: 15, scale: 4
    t.integer  "last_three_month_ranking"
    t.decimal  "last_six_month_total_return",           precision: 15, scale: 4
    t.integer  "last_six_month_ranking"
    t.decimal  "last_year_total_return",                precision: 15, scale: 4
    t.integer  "last_year_ranking"
    t.decimal  "last_two_year_total_return",            precision: 15, scale: 4
    t.integer  "last_two_year_ranking"
    t.decimal  "this_year_total_return",                precision: 15, scale: 4
    t.integer  "this_year_ranking"
    t.decimal  "since_the_inception_total_return",      precision: 15, scale: 4
    t.decimal  "last_three_year_volatility",            precision: 15, scale: 4
    t.string   "last_three_year_volatility_evaluate"
    t.decimal  "last_three_year_risk_factor",           precision: 15, scale: 4
    t.string   "last_three_year_risk_factor_evaluate"
    t.decimal  "last_three_year_sharpe_ratio",          precision: 15, scale: 4
    t.string   "last_three_year_sharpe_ratio_evaluate"
    t.date     "record_at"
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.string   "fund_type"
    t.string   "evaluate_type"
    t.integer  "two_year_rating"
    t.integer  "one_year_rating"
    t.decimal  "last_one_year_volatility",              precision: 15, scale: 4
    t.string   "last_one_year_volatility_evaluate"
    t.decimal  "last_one_year_risk_factor",             precision: 15, scale: 4
    t.string   "last_one_year_risk_factor_evaluate"
    t.decimal  "last_one_year_sharpe_ratio",            precision: 15, scale: 4
    t.string   "last_one_year_sharpe_ratio_evaluate"
    t.integer  "fund_type_classify",                                             default: 0
    t.index ["project_id", "record_at"], name: "index_fund_rankings_on_project_id_and_record_at", using: :btree
    t.index ["record_at", "code"], name: "index_fund_rankings_on_record_at_and_code", using: :btree
  end

  create_table "fund_yields", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.date     "beginning_day"
    t.date     "end_day"
    t.decimal  "beginning_net_worth",  precision: 15, scale: 4
    t.decimal  "end_net_worth",        precision: 15, scale: 4
    t.integer  "fund_chai_fens_count",                          default: 0
    t.integer  "fund_fen_hongs_count",                          default: 0
    t.integer  "yield_type",                                    default: 0
    t.decimal  "yield_rate",           precision: 15, scale: 4
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.index ["project_id", "yield_type"], name: "index_fund_yields_on_project_id_and_yield_type", using: :btree
    t.index ["project_id"], name: "index_fund_yields_on_project_id", using: :btree
  end

  create_table "gem_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.decimal  "total_downloads",               precision: 10
    t.integer  "releases"
    t.string   "current_version"
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

  create_table "index_catalogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_index_catalogs_on_name", using: :btree
  end

  create_table "index_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "index_catalog_id"
    t.text     "intro",            limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["index_catalog_id"], name: "index_index_categories_on_index_catalog_id", using: :btree
    t.index ["name"], name: "index_index_categories_on_name", using: :btree
  end

  create_table "index_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "catalog"
    t.string   "category"
    t.string   "category_intro"
    t.string   "name"
    t.text     "intro",          limit: 16777215
    t.string   "website"
    t.string   "code"
    t.date     "set_up_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "slug"
    t.string   "catalog_slug"
    t.string   "category_slug"
    t.index ["catalog_slug", "category_slug"], name: "index_index_reports_on_catalog_slug_and_category_slug", using: :btree
    t.index ["catalog_slug"], name: "index_index_reports_on_catalog_slug", using: :btree
    t.index ["category_slug"], name: "index_index_reports_on_category_slug", using: :btree
  end

  create_table "kinsfolks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "mother_id"
    t.integer  "son_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mother_id", "son_id"], name: "index_kinsfolks_on_mother_id_and_son_id", using: :btree
  end

  create_table "net_worths", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.decimal  "iopv",       precision: 15, scale: 4
    t.decimal  "dwjz",       precision: 15, scale: 4
    t.decimal  "accnav",     precision: 15, scale: 4
    t.decimal  "ljjz",       precision: 15, scale: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "project_id"
    t.date     "record_at"
    t.integer  "status",                              default: 0
    t.index ["project_id", "record_at"], name: "index_net_worths_on_project_id_and_record_at", using: :btree
    t.index ["project_id"], name: "index_net_worths_on_project_id", using: :btree
  end

  create_table "package_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "project_id"
    t.decimal  "total_downloads",               precision: 10
    t.integer  "releases"
    t.string   "current_version"
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
    t.string   "current_version"
    t.datetime "released"
    t.datetime "first_release"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "others",          limit: 65535
  end

  create_table "project_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "code"
    t.integer  "project_id"
    t.boolean  "boolean_value"
    t.string   "string_value"
    t.integer  "integer_value"
    t.text     "text_value",     limit: 65535
    t.datetime "datetime_value"
    t.date     "date_value"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["project_id", "code"], name: "index_project_items_on_project_id_and_code", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.text     "description",          limit: 65535
    t.string   "website"
    t.string   "wiki"
    t.string   "source_code"
    t.integer  "category_id"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.integer  "identity",                                                    default: 0
    t.text     "author",               limit: 65535
    t.integer  "status",                                                      default: 0
    t.decimal  "popularity",                         precision: 15, scale: 2
    t.integer  "developer_id"
    t.boolean  "today_recommend"
    t.datetime "recommend_at"
    t.string   "human_name"
    t.string   "given_name"
    t.integer  "view_times",                                                  default: 0
    t.string   "code"
    t.integer  "catalog_id"
    t.string   "mold"
    t.string   "slug"
    t.date     "set_up_at"
    t.integer  "mother_son",                                                  default: 0
    t.integer  "release_status",                                              default: 0
    t.integer  "comments_count",                                              default: 0
    t.integer  "mold_type",                                                   default: 0
    t.integer  "fund_chai_fens_count",                                        default: 0, null: false
    t.integer  "fund_fen_hongs_count",                                        default: 0, null: false
    t.datetime "top_at"
    t.index ["code"], name: "index_projects_on_code", using: :btree
  end

  create_table "quickrank_performances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.date     "rating_date"
    t.integer  "project_id"
    t.string   "project_code"
    t.string   "morningstar_code"
    t.string   "project_name"
    t.decimal  "last_day_total_return",            precision: 15, scale: 4
    t.decimal  "last_week_total_return",           precision: 15, scale: 4
    t.decimal  "last_month_total_return",          precision: 15, scale: 4
    t.decimal  "last_three_month_total_return",    precision: 15, scale: 4
    t.decimal  "last_six_month_total_return",      precision: 15, scale: 4
    t.decimal  "last_year_total_return",           precision: 15, scale: 4
    t.decimal  "last_two_year_total_return",       precision: 15, scale: 4
    t.decimal  "last_three_year_total_return",     precision: 15, scale: 4
    t.decimal  "last_five_year_total_return",      precision: 15, scale: 4
    t.decimal  "last_ten_year_total_return",       precision: 15, scale: 4
    t.decimal  "since_the_inception_total_return", precision: 15, scale: 4
    t.decimal  "three_year_volatility",            precision: 15, scale: 4
    t.decimal  "three_year_risk_factor",           precision: 15, scale: 4
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.index ["morningstar_code"], name: "index_quickrank_performances_on_morningstar_code", using: :btree
    t.index ["project_code", "rating_date"], name: "index_quickrank_performances_on_project_code_and_rating_date", using: :btree
    t.index ["project_code"], name: "index_quickrank_performances_on_project_code", using: :btree
    t.index ["project_id"], name: "index_quickrank_performances_on_project_id", using: :btree
    t.index ["rating_date"], name: "index_quickrank_performances_on_rating_date", using: :btree
  end

  create_table "quickrank_portfolios", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.date     "rating_date"
    t.integer  "project_id"
    t.string   "project_code"
    t.string   "morningstar_code"
    t.string   "project_name"
    t.integer  "delivery_style"
    t.decimal  "stock_ratio",         precision: 15, scale: 4
    t.decimal  "bond_ratio",          precision: 15, scale: 4
    t.decimal  "top_ten_stock_ratio", precision: 15, scale: 4
    t.decimal  "top_ten_bond_ratio",  precision: 15, scale: 4
    t.decimal  "net_asset",           precision: 15, scale: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["morningstar_code"], name: "index_quickrank_portfolios_on_morningstar_code", using: :btree
    t.index ["project_code", "rating_date"], name: "index_quickrank_portfolios_on_project_code_and_rating_date", using: :btree
    t.index ["project_code"], name: "index_quickrank_portfolios_on_project_code", using: :btree
    t.index ["project_id"], name: "index_quickrank_portfolios_on_project_id", using: :btree
    t.index ["rating_date"], name: "index_quickrank_portfolios_on_rating_date", using: :btree
  end

  create_table "quickrank_snapshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.date     "rating_date"
    t.integer  "project_id"
    t.string   "project_code"
    t.string   "morningstar_code"
    t.string   "project_name"
    t.string   "project_category"
    t.integer  "star_rating_five_year"
    t.integer  "star_rating_three_year"
    t.date     "record_at"
    t.decimal  "dwjz",                   precision: 15, scale: 4
    t.decimal  "iopv",                   precision: 15, scale: 4
    t.decimal  "yield_rate",             precision: 15, scale: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["morningstar_code"], name: "index_quickrank_snapshots_on_morningstar_code", using: :btree
    t.index ["project_code", "rating_date"], name: "index_quickrank_snapshots_on_project_code_and_rating_date", using: :btree
    t.index ["project_code"], name: "index_quickrank_snapshots_on_project_code", using: :btree
    t.index ["project_id"], name: "index_quickrank_snapshots_on_project_id", using: :btree
    t.index ["rating_date"], name: "index_quickrank_snapshots_on_rating_date", using: :btree
  end

  create_table "quotes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "code"
    t.string   "name"
    t.date     "record_at"
    t.string   "catalog"
    t.decimal  "price",                  precision: 15, scale: 4
    t.decimal  "up_down_number",         precision: 15, scale: 4
    t.decimal  "max_up_number",          precision: 15, scale: 4
    t.decimal  "min_down_number",        precision: 15, scale: 4
    t.decimal  "open_number",            precision: 15, scale: 4
    t.decimal  "yesterday_close_number", precision: 15, scale: 4
    t.decimal  "up_down_rate",           precision: 15, scale: 4
    t.datetime "last_updated_at"
    t.decimal  "turnover",               precision: 15, scale: 4
    t.decimal  "volume_of_business",     precision: 15, scale: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "stock_id"
    t.index ["stock_id", "record_at"], name: "index_quotes_on_stock_id_and_record_at", using: :btree
  end

  create_table "redactor_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "user_id"
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["assetable_type", "assetable_id"], name: "idx_redactor_assetable", using: :btree
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_redactor_assetable_type", using: :btree
  end

  create_table "sites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["slug"], name: "index_sites_on_slug", using: :btree
  end

  create_table "stocks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.string   "code"
    t.string   "catalog"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_stocks_on_code", using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
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

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string  "name",                                     collation: "utf8_bin"
    t.integer "taggings_count",               default: 0
    t.string  "slug"
    t.text    "description",    limit: 65535
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "task_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "key"
    t.string   "level"
    t.text     "content",    limit: 65535
    t.text     "ext_info",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "user_favor_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "comment_id"], name: "index_user_favor_comments_on_user_id_and_comment_id", using: :btree
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
    t.string   "email",                  limit: 191,                 null: false
    t.string   "encrypted_password",                                 null: false
    t.string   "reset_password_token",   limit: 191
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "name"
    t.boolean  "is_admin",                           default: false
    t.string   "avatar"
    t.string   "username"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
