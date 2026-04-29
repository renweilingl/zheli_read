# frozen_string_literal: true

class RecommendedContent < ApplicationRecord
  belongs_to :grade

  validates :name, presence: true, length: { maximum: 10 }
  validates :grade_id, presence: true

  default_scope { order(sn: :asc, id: :desc) }
  scope :sorted, -> { order(sn: :asc, id: :desc) }

  def status_text
    published? ? '已发布' : '草稿'
  end
end
