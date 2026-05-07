# frozen_string_literal: true

class CategorySub < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, length: { maximum: 100 }
  validates :category_id, presence: true

  scope :sorted, -> { order(id: :desc)}
end
