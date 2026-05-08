# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :supplier, optional: true
  belongs_to :category
  has_and_belongs_to_many :grades, join_table: :book_grades
  has_and_belongs_to_many :compilations, join_table: :compilation_books
  has_and_belongs_to_many :category_subs, join_table: :category_sub_books
  has_many :chapters
  has_many :contents

  # 验证
  validates :name, presence: true, length: { maximum: 100 }

  def categories_array
    categories || []
  end

  def themes_array
    themes || []
  end

  def collections_array
    collections || []
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    ["author", "id", "name", "supplier_id", "themes"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "chapters", "compilations", "grades", "supplier"]
  end
end
