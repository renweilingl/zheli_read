# frozen_string_literal: true

class Compilation < ApplicationRecord
  # ===== 二级类型 =====
  SUB_TYPES = {
    picture_book: 'picture_book',       # 绘本
    comic: 'comic',                   # 漫画
    bridge_book: 'bridge_book',       # 桥梁书
    english: 'english',               # 英语
    ip_picture_book: 'ip_picture_book'  # IP图画书
  }.freeze

  SUB_TYPE_NAMES = {
    picture_book: '绘本',
    comic: '漫画',
    bridge_book: '桥梁书',
    english: '英语',
    ip_picture_book: 'IP图画书'
  }.freeze

  # ===== 预设年龄段 =====
  AGE_GROUPS = {
    '0-3' => '0-3岁',
    '3-6' => '3-6岁',
    '6-9' => '6-9岁',
    '9-12' => '9-12岁',
    '12+' => '12岁以上',
    '0-6' => '0-6岁',
    '3-12' => '3-12岁'
  }.freeze

  # ===== 主题分类 =====
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
    life: '生活习惯',
    emotion: '情绪管理',
    cognition: '认知启蒙',
    science: '科普百科',
    art: '艺术创意',
    language: '语言发展',
    social: '社会交往',
    creativity: '创造力',
    family: '亲子关系',
    culture: '文化传承'
  }.freeze

  # ===== 验证 =====
  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { case_sensitive: false }
  validates :recommended_age, presence: true, length: { maximum: 20 }
  validates :editor_recommendation, length: { maximum: 15 }, allow_blank: true
  validates :min_age, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :max_age, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  validate :validate_age_range
  validate :validate_age_groups

  # ===== 排序 =====
  default_scope { order(sort_order: :asc, created_at: :desc) }

  # ===== 类方法 =====
  class << self
    def search(keyword)
      return all if keyword.blank?

      where('name LIKE ?', "%#{keyword}%")
    end

    def filter_by_status(status)
      return all if status.blank?

      where(status: status)
    end

    def filter_by_age_group(age_group)
      return all if age_group.blank?

      where('age_groups @>?', "\"#{age_group}\"")
    end

    def filter_by_sub_type(type)
      return all if type.blank?

      where(sub_type: type)
    end

    def filter_by_category(category)
      return all if category.blank?

      where('categories @>?', "\"#{category}\"")
    end
  end

  # ===== 实例方法 =====

  # 状态名称
  def status_name
    case status
    when 'draft' then '草稿'
    when 'published' then '已上线'
    when 'offline' then '已下线'
    else status
    end
  end

  # 二级类型名称
  def sub_type_name
    SUB_TYPE_NAMES[sub_type.to_sym] || sub_type
  end

  # 年龄段数组
  def age_groups_array
    age_groups || []
  end

  # 年龄段名称
  def age_groups_names
    age_groups_array.map { |g| AGE_GROUPS[g.to_sym] || g }.join(', ')
  end

  # 年龄范围
  def age_range
    "#{min_age || 0}~#{max_age || 99}岁"
  end

  # 分类数组
  def categories_array
    categories || []
  end

  # 主题数组
  def themes_array
    themes || []
  end

  # 主题名称
  def themes_names
    themes_array.map { |t| THEME_NAMES[t.to_sym] || t }.join(', ')
  end

  # 标签数组
  def tags_array
    tags || []
  end

  # ===== 封面图片相关 =====

  # 封面完整性检查
  def covers_complete?
    landscape_cover_url.present? && portrait_cover_url.present? && square_cover_url.present?
  end

  # 获取主封面
  def main_cover_url
    landscape_cover_url || banner_image_url
  end

  # ===== 发布相关 =====

  def publish!
    update(status: :published)
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

  # ===== 封面规格说明 =====
  def self.cover_specifications
    {
      banner: { width: 1500, height: 932, max_size: 500, unit: 'KB', desc: '合辑banner' },
      landscape: { width: 1125, height: 540, max_size: 500, unit: 'KB', desc: '横图封面' },
      portrait: { width: 600, height: 768, max_size: 300, unit: 'KB', desc: '长方形封面' },
      square: { width: 600, height: 600, max_size: 300, unit: 'KB', desc: '正方形封面' }
    }
  end

  private

  def validate_age_range
    if min_age.present? && max_age.present? && min_age > max_age
      errors.add(:min_age, '最小年龄不能大于最大年龄')
    end
  end

  def validate_age_groups
    if age_groups.present? && age_groups.length < 1
      errors.add(:age_groups, '请至少选择一个年龄段')
    end
  end
end
