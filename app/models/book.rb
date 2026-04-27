# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :supplier, optional: true
  has_and_belongs_to_many :grades, join_table: :book_grades
  has_many :chapters

  # 主题分类
  THEMES = {
    life: 'life',                 # 生活习惯
    emotion: 'emotion',           # 情绪管理
    cognition: 'cognition',       # 认知启蒙
    science: 'science',           # 科普百科
    art: 'art',                   # 艺术创意
    language: 'language',        # 语言发展
    social: 'social',            # 社会交往
    creativity: 'creativity',     # 创造力
    family: 'family',            # 亲子关系
    culture: 'culture'           # 文化传承
  }.freeze

  THEME_NAMES = {
    cognition: '认知启蒙',
    science: '科普百科',
    art: '艺术创意',
    language: '语言发展',
    social: '社会交往',
    creativity: '创造力',
    family: '亲子关系',
    culture: '文化传承'
  }.freeze

  # 验证
  validates :name, presence: true, length: { maximum: 100 }
  #validate :validate_themes

  def categories_array
    categories || []
  end

  def themes_array
    themes || []
  end

  def themes_names
    themes_array.map { |t| THEME_NAMES[t.to_sym] || t }.join(', ')
  end

  def collections_array
    collections || []
  end

  private

  def validate_themes
    if themes.present? && themes.length < 1
      errors.add(:themes, '请至少选择一个主题')
    end
  end

   def self.ransackable_attributes(auth_object = nil)
    ["author", "id", "name", "supplier_id", "themes"]
  end
end
