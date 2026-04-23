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

end
