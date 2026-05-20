class SplashAd < ApplicationRecord
  audited
  
  belongs_to :book, optional: true
  belongs_to :category, optional: true
  
  # 链接类型
  LINK_TYPES = {
    single_book: '单本图书',
    category: '图书分类'
  }.freeze
  
  # 推送范围
  PUSH_SCOPES = {
    all_users: 'all_users',
    age_range: 'age_range',
    specific_users: 'specific_users'
  }.freeze
  
  # 推送方式
  PUSH_MODES = {
    immediate: 'immediate',
    first_open_daily: 'first_open_daily'
  }.freeze
  
  # 状态
  STATUSES = {
    draft: 'draft',
    scheduled: 'scheduled',
    active: 'active',
    expired: 'expired',
    disabled: 'disabled'
  }.freeze
  
  enum :link_type, {
    single_book: 'single_book',
    category: 'category',
  }, prefix: true

  enum :push_scope, PUSH_SCOPES
  enum :push_mode, PUSH_MODES
  enum :status, STATUSES
  
  # 验证
  validates :image_url, presence: true
  validates :link_type, presence: true
  validates :push_scope, presence: true
  validates :push_mode, presence: true
  
  validate :link_type_consistency
  
  # 年龄段验证
  validates :min_age, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 18, allow_nil: true }
  validates :max_age, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 18, allow_nil: true }
  validate :age_range_validity
  
  # 作用域
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_link_type, ->(link_type) { where(link_type: link_type) if link_type.present? }
  scope :by_push_scope, ->(push_scope) { where(push_scope: push_scope) if push_scope.present? }
  scope :active_now, -> { 
    where(status: :active)
#    .where('start_time <= ?', Time.current)
#    .where('end_time >= ?', Time.current)
  }
  scope :ordered, -> { order(created_at: :desc) }
  

  def link_type_name
    LINK_TYPES[link_type.to_sym] || link_type
  end
  
  def age_range_display
    return nil unless push_scope == 'age_range'
    "#{min_age || 0} ~ #{max_age || 18} 岁"
  end
  
  def time_range_display
    "#{start_time&.strftime('%Y-%m-%d %H:%M')} ~ #{end_time&.strftime('%Y-%m-%d %H:%M')}"
  end
  
  def delivery_rate_display
    return '0%' if send_count.zero?
    "#{(delivery_rate * 100).round(2)}%"
  end
  
  def click_rate_display
    return '0%' if send_count.zero?
    "#{((click_count.to_f / send_count) * 100).round(2)}%"
  end
  
  def active?
    status == 'active' && start_time <= Time.current && end_time >= Time.current
  end
  
  def expired?
    end_time < Time.current
  end
  
  def can_publish?
    status == 'draft' && start_time && end_time
  end
  
  def publish!
    return false unless can_publish?
    
    if start_time > Time.current
      update!(status: :scheduled)
    else
      update!(status: :active)
    end
  end
  
  def disable!
    update!(status: :disabled)
  end
  
  def enable!
    update!(status: :active)
  end
  
  private
  
  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?
    
    if end_time <= start_time
      errors.add(:end_time, '必须晚于开始时间')
    end
  end
  
  def link_type_consistency
    case link_type
    when 'single_book'
      errors.add(:book_id, '不能为空') if book_id.blank?
    when 'category'
      errors.add(:category_id, '不能为空') if category_id.blank?
    end
  end
  
  def age_range_validity
    return unless push_scope == 'age_range'
    
    if min_age.blank? || max_age.blank?
      errors.add(:base, '指定年龄段时，最小年龄和最大年龄都必须填写')
    elsif min_age > max_age
      errors.add(:min_age, '不能大于最大年龄')
    end
  end
end
