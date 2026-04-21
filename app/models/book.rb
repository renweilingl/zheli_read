# frozen_string_literal: true

class Book < ApplicationRecord
  # 关联
  belongs_to :supplier, optional: true

  # 枚举定义
  enum :payment_type, {
    free: 'free',       # 免费
    paid: 'paid',       # 付费
    vip: 'vip'         # 会员专享
  }, prefix: true

  enum :orientation, {
    portrait: 'portrait',   # 竖屏
    landscape: 'landscape'  # 横屏
  }, prefix: true

  enum :status, {
    draft: 'draft',         # 草稿
    published: 'published', # 已上线
    offline: 'offline'      # 已下线
  }, prefix: true

  # 绘本类型
  BOOK_TYPES = {
    picture_book: 'picture_book',           # 绘本
    comic: 'comic',                         # 漫画
    illustrated: 'illustrated',             # 图画书
    early_education: 'early_education',    # 早教
    puzzle: 'puzzle',                      # 益智
    fairy_tale: 'fairy_tale',              # 童话
    other: 'other'                         # 其他
  }.freeze

  BOOK_TYPE_NAMES = {
    picture_book: '绘本',
    comic: '漫画',
    illustrated: '图画书',
    early_education: '早教',
    puzzle: '益智',
    fairy_tale: '童话',
    other: '其他'
  }.freeze

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

  # 验证
  validates :name, presence: true, length: { maximum: 100 }
  validates :book_type, presence: true
  validates :recommended_age, presence: true, length: { maximum: 20 }
  validates :min_age, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :max_age, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :validate_age_range
  validate :validate_themes

  # 排序
  default_scope { order(created_at: :desc) }

  # 类方法
  class << self
    def search(keyword)
      return all if keyword.blank?

      where('name LIKE ?', "%#{keyword}%")
    end

    def filter_by_status(status)
      return all if status.blank?

      where(status: status)
    end

    def filter_by_payment_type(type)
      return all if type.blank?

      where(payment_type: type)
    end

    def filter_by_book_type(type)
      return all if type.blank?

      where(book_type: type)
    end

    def filter_by_supplier(supplier_id)
      return all if supplier_id.blank?

      where(supplier_id: supplier_id)
    end
  end

  # 实例方法
  def book_type_name
    BOOK_TYPE_NAMES[book_type.to_sym] || book_type
  end

  def payment_type_name
    case payment_type
    when 'free' then '免费'
    when 'paid' then '付费'
    when 'vip' then '会员专享'
    else payment_type
    end
  end

  def orientation_name
    case orientation
    when 'portrait' then '竖屏'
    when 'landscape' then '横屏'
    else orientation
    end
  end

  def status_name
    case status
    when 'draft' then '草稿'
    when 'published' then '已上线'
    when 'offline' then '已下线'
    else status
    end
  end

  def categories_array
    categories || []
  end

  def themes_array
    themes || []
  end

  def themes_names
    themes_array.map { |t| THEME_NAMES[t.to_sym] || t }.join(', ')
  end

  def level_one_tags_array
    level_one_tags || []
  end

  def level_two_tags_array
    level_two_tags || []
  end

  def awards_array
    awards || []
  end

  def collections_array
    collections || []
  end

  # 版权有效期
  def copyright_period
    if copyright_start_date.present? && copyright_end_date.present?
      "#{copyright_start_date} 至 #{copyright_end_date}"
    elsif copyright_start_date.present?
      "#{copyright_start_date} 至 永久"
    else
      '-'
    end
  end

  def copyright_expired?
    copyright_end_date.present? && copyright_end_date < Date.today
  end

  # 发布
  def publish!
    update(status: :published)
  end

  # 下线
  def offline!
    update(status: :offline)
  end

  private

  def validate_age_range
    if min_age.present? && max_age.present? && min_age > max_age
      errors.add(:min_age, '最小年龄不能大于最大年龄')
    end
  end

  def validate_themes
    if themes.present? && themes.length < 1
      errors.add(:themes, '请至少选择一个主题')
    end
  end
end
