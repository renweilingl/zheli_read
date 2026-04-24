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

ActiveRecord::Schema[7.1].define(version: 2026_04_09_065251) do
  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "level", default: 1, null: false
    t.integer "sn", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_categories_on_level"
  end

  create_table "compilations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "合辑名称"
    t.string "banner_image_url", comment: "合辑banner图片URL (1500×932, ≤500KB)"
    t.string "banner_image_name", comment: "合辑banner图片文件名"
    t.string "landscape_cover_url", comment: "横图封面URL (1125×540, ≤500KB)"
    t.string "landscape_cover_name", comment: "横图封面文件名"
    t.string "portrait_cover_url", comment: "长方形封面URL (600×768, ≤300KB)"
    t.string "portrait_cover_name", comment: "长方形封面文件名"
    t.string "square_cover_url", comment: "正方形封面URL (600×600, ≤300KB)"
    t.string "square_cover_name", comment: "正方形封面文件名"
    t.json "age_groups", comment: "年龄段勾选（多选）"
    t.integer "min_age", default: 0, comment: "最小年龄"
    t.integer "max_age", default: 99, comment: "最大年龄"
    t.string "recommended_age", comment: "最佳年龄推荐"
    t.bigint "first_category_id", comment: "一级分类"
    t.bigint "second_category_id", comment: "二级分类"
    t.json "themes", comment: "主题分类"
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
    t.index ["first_category_id"], name: "index_compilations_on_first_category_id"
    t.index ["name"], name: "index_compilations_on_name", unique: true
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
    t.string "description", limit: 32
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

end
