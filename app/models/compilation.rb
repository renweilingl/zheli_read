# frozen_string_literal: true

class Compilation < ApplicationRecord
  has_and_belongs_to_many :grades, join_table: :compilation_grades
  has_and_belongs_to_many :categories, join_table: :compilation_categories

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { case_sensitive: false }
  #validates :recommended_age, presence: true, length: { maximum: 20 }
  validates :editor_recommendation, length: { maximum: 15 }, allow_blank: true
  #validates :min_age, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  #validates :max_age, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  #validate :validate_age_range
  #validate :validate_age_groups

  #def age_groups_array
  #  age_groups || []
  #end

  # 年龄段名称
  #def age_groups_names
  #  age_groups_array.map { |g| AGE_GROUPS[g.to_sym] || g }.join(', ')
  #end

  # 年龄范围
  #def age_range
  #  "#{min_age || 0}~#{max_age || 99}岁"
  #end

  # 标签数组
  def tags_array
    tags || []
  end

  #def themes_array
  #  themes || []
  #end

  # 封面完整性检查
  def covers_complete?
    landscape_cover_url.present? && portrait_cover_url.present? && square_cover_url.present?
  end

  # 获取主封面
  def main_cover_url
    landscape_cover_url || banner_image_url
  end

  def offline!
    update(status: :offline)
  end

  def toggle_status
    if draft?
      publish!
      '已上线'
    elsif published?
      offline!
      '已下线'
    else
      update(status: :draft)
      '已恢复为草稿'
    end
  end

  def self.cover_specifications
    {
      banner: { width: 1500, height: 932, max_size: 500, unit: 'KB', desc: '合辑banner' },
      landscape: { width: 1125, height: 540, max_size: 500, unit: 'KB', desc: '横图封面' },
      portrait: { width: 600, height: 768, max_size: 300, unit: 'KB', desc: '长方形封面' },
      square: { width: 600, height: 600, max_size: 300, unit: 'KB', desc: '正方形封面' }
    }
  end

  private

  #def validate_age_range
  #  if min_age.present? && max_age.present? && min_age > max_age
  #    errors.add(:min_age, '最小年龄不能大于最大年龄')
  #  end
  #end

  #def validate_age_groups
  #  if age_groups.present? && age_groups.length < 1
  #    errors.add(:age_groups, '请至少选择一个年龄段')
  #  end
  #end

  def self.ransackable_attributes(auth_object = nil)
    ["author", "banner_image_name", "banner_image_url", "content_description", "created_at", "description", "editor_recommendation", "first_category_id", "id", "id_value", "intro_image_name", "intro_image_url", "landscape_cover_name", "landscape_cover_url", "name", "portrait_cover_name", "portrait_cover_url", "publisher", "square_cover_name", "square_cover_url", "tags", "total_count", "updated_at"]
  end
end
