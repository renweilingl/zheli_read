# frozen_string_literal: true

class AddCascadeDeleteToForeignKeys < ActiveRecord::Migration[7.1]
  FK_PAIRS = [
    [:book_grades, :books],
    [:book_grades, :grades],
    [:compilation_books, :books],
    [:compilation_books, :compilations],
    [:compilation_grades, :compilations],
    [:compilation_grades, :grades],
    [:category_sub_books, :books],
    [:category_sub_books, :category_subs],
    [:chapters, :books],
  ].freeze

  def up
    FK_PAIRS.each do |table, ref|
      begin
        remove_foreign_key table, ref
      rescue ArgumentError
        # FK doesn't exist, skip removal
      end
      add_foreign_key table, ref, on_delete: :cascade
    end
  end

  def down
    FK_PAIRS.each do |table, ref|
      begin
        remove_foreign_key table, ref
      rescue ArgumentError
        # FK doesn't exist, skip removal
      end
      add_foreign_key table, ref
    end
  end
end
