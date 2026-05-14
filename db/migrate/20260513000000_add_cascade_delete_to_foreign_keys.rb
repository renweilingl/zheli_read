# frozen_string_literal: true

class AddCascadeDeleteToForeignKeys < ActiveRecord::Migration[7.1]
  def up
    remove_foreign_key :book_grades, :books
    remove_foreign_key :book_grades, :grades
    remove_foreign_key :compilation_books, :books
    remove_foreign_key :compilation_books, :compilations
    remove_foreign_key :compilation_grades, :compilations
    remove_foreign_key :compilation_grades, :grades
    remove_foreign_key :category_sub_books, :books
    remove_foreign_key :category_sub_books, :category_subs
    remove_foreign_key :chapters, :books

    add_foreign_key :book_grades, :books, on_delete: :cascade
    add_foreign_key :book_grades, :grades, on_delete: :cascade
    add_foreign_key :compilation_books, :books, on_delete: :cascade
    add_foreign_key :compilation_books, :compilations, on_delete: :cascade
    add_foreign_key :compilation_grades, :compilations, on_delete: :cascade
    add_foreign_key :compilation_grades, :grades, on_delete: :cascade
    add_foreign_key :category_sub_books, :books, on_delete: :cascade
    add_foreign_key :category_sub_books, :category_subs, on_delete: :cascade
    add_foreign_key :chapters, :books, on_delete: :cascade
  end

  def down
    remove_foreign_key :book_grades, :books
    remove_foreign_key :book_grades, :grades
    remove_foreign_key :compilation_books, :books
    remove_foreign_key :compilation_books, :compilations
    remove_foreign_key :compilation_grades, :compilations
    remove_foreign_key :compilation_grades, :grades
    remove_foreign_key :category_sub_books, :books
    remove_foreign_key :category_sub_books, :category_subs
    remove_foreign_key :chapters, :books

    add_foreign_key :book_grades, :books
    add_foreign_key :book_grades, :grades
    add_foreign_key :compilation_books, :books
    add_foreign_key :compilation_books, :compilations
    add_foreign_key :compilation_grades, :compilations
    add_foreign_key :compilation_grades, :grades
    add_foreign_key :category_sub_books, :books
    add_foreign_key :category_sub_books, :category_subs
    add_foreign_key :chapters, :books
  end
end
