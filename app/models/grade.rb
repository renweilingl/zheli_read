class Grade < ApplicationRecord
  audited

  has_and_belongs_to_many :compilations, join_table: :compilation_grades
  has_and_belongs_to_many :books, join_table: :book_grades

  has_many :recommends, dependent: :destroy

  has_many :ranks, dependent: :destroy

  def book_ranks
    ranks.where(category_id: Category.find_by(name: "图书").id)
  end

  def audio_ranks 
    ranks.where(category_id: Category.find_by(name: "有声").id)
  end

  def cartoon_ranks
    ranks.where(category_id: Category.find_by(name: "漫画").id)
  end
end
