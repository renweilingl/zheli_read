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

ActiveRecord::Schema[7.1].define(version: 2026_04_22_070028) do
  create_table "books", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "book_type", default: "book", null: false, comment: "合辑类型：图书|绘本"
    t.string "name", null: false, comment: "绘本名称"
    t.string "cover_image_url", comment: "绘本封面URL"
    t.string "lan_type", comment: "语言类型"
    t.integer "min_age", default: 0, comment: "最小年龄"
    t.integer "max_age", default: 99, comment: "最大年龄"
    t.string "recommended_age", comment: "最佳年龄推荐"
    t.boolean "cat_display", default: false, comment: "分类展示"
    t.json "themes", comment: "主题"
    t.bigint "supplier_id", comment: "归属供应商"
    t.boolean "has_copyright", default: false, comment: "是否有版权"
    t.string "payment_type", default: "free", comment: "付费类型: free/paid/vip"
    t.decimal "price", precision: 10, scale: 2, default: "0.0", comment: "单价"
    t.string "publisher", comment: "出版社"
    t.boolean "has_isbn", default: false, comment: "是否存在ISBN"
    t.string "author", comment: "作者"
    t.string "translator", comment: "译者"
    t.string "compiler", comment: "编著"
    t.string "illustrator", comment: "编绘"
    t.string "editor_in_chief", comment: "主编"
    t.json "awards", comment: "关联奖项"
    t.text "description", comment: "内容简介"
    t.string "orientation", default: "portrait", comment: "横屏/竖屏: portrait/landscape"
    t.string "intro_image_url", comment: "图片简介URL"
    t.text "image_description", comment: "图片文字(app不展示)"
    t.boolean "purchasable", default: true, comment: "是否可购买"
    t.string "editor_recommendation", comment: "编辑推荐语"
    t.string "detail_recommendation", comment: "详情页推荐语"
    t.integer "page_count", default: 0, comment: "页数"
    t.boolean "full_trial_read", default: false, comment: "是否整本试读"
    t.integer "trial_page_count", default: 0, comment: "试读页数"
    t.integer "word_count", default: 0, comment: "字数"
    t.text "remark", comment: "备注"
    t.datetime "scheduled_online_at", comment: "定时上线时间"
    t.boolean "locked", default: false, comment: "是否锁定"
    t.string "status", default: "draft", comment: "状态: draft/published/offline"
    t.integer "base_read_count", default: 0, comment: "基础阅读人数"
    t.integer "base_rating_count", default: 0, comment: "基础评分人数"
    t.decimal "base_rating", precision: 3, scale: 1, default: "0.0", comment: "基础评分"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_type"], name: "index_books_on_book_type"
    t.index ["name"], name: "index_books_on_name"
    t.index ["payment_type"], name: "index_books_on_payment_type"
    t.index ["status"], name: "index_books_on_status"
    t.index ["supplier_id"], name: "index_books_on_supplier_id"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "level", default: 1, null: false
    t.boolean "is_recommended", default: false
    t.integer "sn", default: 0
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_recommended"], name: "index_categories_on_is_recommended"
    t.index ["level"], name: "index_categories_on_level"
  end

  create_table "chapters", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "book_id", null: false, comment: "所属绘本"
    t.string "name", null: false, comment: "章节名称"
    t.integer "chapter_number", null: false, comment: "章节序号"
    t.string "cover_image_url", comment: "章节封面图片URL"
    t.string "cover_image_name", comment: "章节封面图片名"
    t.string "content_file_url", comment: "章节内容文件URL"
    t.string "content_file_name", comment: "章节内容文件名"
    t.string "content_file_type", comment: "内容文件类型 (epub/pdf/txt)"
    t.integer "content_file_size", comment: "内容文件大小(字节)"
    t.boolean "is_free", default: false, comment: "是否免费"
    t.boolean "is_published", default: false, comment: "是否上线"
    t.integer "sort_order", default: 0, comment: "排序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_chapters_on_book_id"
  end

  create_table "contents", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title", null: false, comment: "标题"
    t.text "description", comment: "简介"
    t.string "tags", comment: "标签（JSON格式）"
    t.string "grade_level", comment: "一级分类"
    t.string "second_level", comment: "二级分类"
    t.string "third_level", comment: "三级分类"
    t.string "file_type", comment: "文件类型：epub/pdf/mp3/mp4"
    t.string "file_url", comment: "文件URL"
    t.string "file_name", comment: "原始文件名"
    t.integer "file_size", comment: "文件大小（字节）"
    t.integer "duration", comment: "时长（秒）- 音视频"
    t.text "copy_right", comment: "版权信息"
    t.string "cover_img", comment: "封面"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_type"], name: "index_contents_on_file_type"
    t.index ["grade_level"], name: "index_contents_on_grade_level"
    t.index ["title"], name: "index_contents_on_title"
  end

  create_table "grades", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "group_name", limit: 8
    t.string "name", limit: 16
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "books", "suppliers"
  add_foreign_key "chapters", "books"
end
