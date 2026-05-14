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

ActiveRecord::Schema[7.1].define(version: 2026_05_14_074222) do
  create_table "audits", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "authors", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "作者名"
    t.string "head_img", null: false, comment: "头像"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_grades", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "grade_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "grade_id"], name: "index_book_grades_on_book_id_and_grade_id", unique: true
    t.index ["book_id"], name: "index_book_grades_on_book_id"
    t.index ["grade_id"], name: "index_book_grades_on_grade_id"
  end

  create_table "book_levels", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false, comment: "等级名称"
    t.integer "sn", default: 0, null: false, comment: "序号"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "绘本名称"
    t.string "cover_image_url", comment: "绘本封面URL"
    t.bigint "category_id", comment: "绘本类型"
    t.json "themes", comment: "主题"
    t.bigint "supplier_id", comment: "归属供应商"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "book_level_id"
    t.bigint "author_id"
    t.bigint "compilations"
    t.index ["category_id"], name: "index_books_on_category_id"
    t.index ["name"], name: "index_books_on_name"
    t.index ["supplier_id"], name: "index_books_on_supplier_id"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "level", default: 1, null: false
    t.integer "sn", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_categories_on_level"
  end

  create_table "category_sub_books", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "category_sub_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "category_sub_id"], name: "index_category_sub_books_on_book_id_and_category_sub_id", unique: true
    t.index ["book_id"], name: "index_category_sub_books_on_book_id"
    t.index ["category_sub_id"], name: "index_category_sub_books_on_category_sub_id"
  end

  create_table "category_subs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "category_id", null: false, comment: "关联分类"
    t.string "name", null: false, comment: "子类名称"
    t.string "icon", comment: "图标URL"
    t.integer "sn", default: 0, comment: "排序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_subs_on_category_id"
  end

  create_table "chapters", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "book_id", null: false, comment: "所属绘本"
    t.string "name", null: false, comment: "章节名称"
    t.string "cover_image_url", comment: "章节封面图片URL"
    t.string "content_file_url", comment: "章节内容文件URL"
    t.string "content_file_name", comment: "章节内容文件名"
    t.string "content_file_type", comment: "内容文件类型 (epub/pdf/txt)"
    t.boolean "is_free", default: false, comment: "是否免费"
    t.boolean "is_published", default: false, comment: "是否上线"
    t.integer "sn", default: 0, comment: "排序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_chapters_on_book_id"
  end

  create_table "compilation_books", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "compilation_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_compilation_books_on_book_id"
    t.index ["compilation_id", "book_id"], name: "index_compilation_books_on_compilation_id_and_book_id", unique: true
    t.index ["compilation_id"], name: "index_compilation_books_on_compilation_id"
  end

  create_table "compilation_categories", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "compilation_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_compilation_categories_on_category_id"
    t.index ["compilation_id", "category_id"], name: "index_compilation_categories_on_compilation_id_and_category_id", unique: true
    t.index ["compilation_id"], name: "index_compilation_categories_on_compilation_id"
  end

  create_table "compilation_grades", id: false, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "compilation_id", null: false
    t.bigint "grade_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["compilation_id", "grade_id"], name: "index_compilation_grades_on_compilation_id_and_grade_id", unique: true
    t.index ["compilation_id"], name: "index_compilation_grades_on_compilation_id"
    t.index ["grade_id"], name: "index_compilation_grades_on_grade_id"
  end

  create_table "compilations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "合辑名称"
    t.string "banner_image_url", comment: "合辑banner图片URL (1500×932, ≤500KB)"
    t.string "banner_image_name", comment: "合辑banner图片文件名"
    t.string "landscape_cover_url", comment: "横图封面URL (1125×540, ≤500KB)"
    t.string "landscape_cover_name", comment: "横图封面文件名"
    t.string "editor_recommendation", comment: "编辑推荐语（15字以内）"
    t.string "publisher", comment: "出版社"
    t.integer "total_count", default: 0, comment: "合辑总集数"
    t.string "author", comment: "作者"
    t.string "tags", comment: "内容标签"
    t.string "intro_image_url", comment: "图片简介URL"
    t.string "intro_image_name", comment: "图片简介文件名"
    t.text "content_description", comment: "合辑简介（富文本/Markdown）"
    t.text "description", comment: "内容简介"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_compilations_on_name", unique: true
  end

  create_table "content_groups", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "recommend_id", null: false, comment: "关联年级"
    t.string "name", null: false, comment: "小组名称"
    t.string "group_type", null: false, comment: "小组类型"
    t.integer "sn", default: 0, comment: "排序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recommend_id"], name: "index_content_groups_on_recommend_id"
  end

  create_table "contents", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "content_group_id", null: false, comment: "关联内容分组"
    t.string "content_type", null: false, comment: "类型"
    t.string "img_url", comment: "图片链接"
    t.bigint "compilation_id", comment: "合辑信息"
    t.bigint "book_id", comment: "单本信息"
    t.bigint "recommend_id", comment: "推荐信息"
    t.bigint "author_id", comment: "作者信息"
    t.integer "sn", default: 0, comment: "排序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_group_id"], name: "index_contents_on_content_group_id"
  end

  create_table "grades", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "group_name", limit: 8
    t.string "name", limit: 16
    t.string "description", limit: 32
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "packages", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", limit: 16, comment: "套餐名字"
    t.float "origin_price", comment: "原价"
    t.float "price", comment: "实际原价"
    t.integer "sn", default: 0, comment: "排序"
    t.integer "effective_days", comment: "有效天数"
    t.boolean "is_delete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "push_notifications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "push_type", default: 0, null: false
    t.string "title", limit: 20, null: false
    t.string "body", limit: 50, null: false
    t.string "link_url", limit: 500
    t.integer "push_scope", default: 0, null: false
    t.integer "min_age"
    t.integer "max_age"
    t.text "user_group"
    t.integer "status", default: 0, null: false
    t.datetime "scheduled_at"
    t.datetime "sent_at"
    t.integer "send_count", default: 0
    t.integer "click_count", default: 0
    t.decimal "delivery_rate", precision: 5, scale: 2, default: "0.0"
    t.boolean "is_delete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["push_type"], name: "index_push_notifications_on_push_type"
    t.index ["status"], name: "index_push_notifications_on_status"
  end

  create_table "recommends", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "grade_id", null: false, comment: "关联年级"
    t.string "name", null: false, comment: "推荐内容名称"
    t.integer "sn", default: 0, comment: "排序"
    t.boolean "status", default: true, comment: "状态: true发布/false草稿"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color", limit: 16, default: ""
    t.index ["grade_id", "sn"], name: "index_recommends_on_grade_id_and_sn"
    t.index ["grade_id"], name: "index_recommends_on_grade_id"
  end

  create_table "suppliers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "供应商名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_suppliers_on_name"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "crypted_password"
    t.string "salt"
    t.string "role", default: "editor", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "book_grades", "books"
  add_foreign_key "book_grades", "grades"
  add_foreign_key "books", "suppliers"
  add_foreign_key "category_sub_books", "books"
  add_foreign_key "category_sub_books", "category_subs"
  add_foreign_key "category_subs", "categories"
  add_foreign_key "chapters", "books"
  add_foreign_key "compilation_books", "books"
  add_foreign_key "compilation_books", "compilations"
  add_foreign_key "compilation_categories", "categories"
  add_foreign_key "compilation_categories", "compilations"
  add_foreign_key "compilation_grades", "compilations"
  add_foreign_key "compilation_grades", "grades"
  add_foreign_key "content_groups", "recommends"
  add_foreign_key "contents", "content_groups"
  add_foreign_key "recommends", "grades"
end
