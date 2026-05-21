class SplashAd < ApplicationRecord
  audited
  
  belongs_to :book, optional: true
  belongs_to :category, optional: true
  
  # 链接类型
  LINK_TYPES = {
    single_book: '单本图书',
    category: '图书分类'
  }.freeze

  PUSH_SCOPES = {
    all_users: '所有用户',
    age_range: '按年龄段',
    specific_users: '指定用户'
  }.freeze
  
  PUSH_MODES = {
    immediate: '定时推送',
    first_open_daily: '首次打开APP推送'
  }.freeze
  
  STATUSES = {
    draft: '草稿',
    active: '投放中',
    expired: '已过期',
    disabled: '已停用'
  }.freeze
  
  enum :link_type, {
    single_book: 'single_book',
    category: 'category',
  }, prefix: true

  enum :push_scope, {
    all_users: 'all_users',
    age_range: 'age_range',
    specific_users: 'specific_users'
  }, prefix: true

  enum :push_mode, {
    immediate: 'immediate',
    first_open_daily: 'first_open_daily'
  }, prefix: true

  enum :status, {
    draft: 'draft',
    active: 'active',
    expired: 'expired',
    disabled: 'disabled'
  }, prefix: true 
  
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

  def push_scope_name
    PUSH_SCOPES[push_scope.to_sym] || push_scope
  end

  def push_mode_name
    PUSH_MODES[push_mode.to_sym] || push_mode
  end

  def status_name
    STATUSES[status.to_sym] || status
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

  def self.ransackable_attributes(auth_object = nil)
    ["book_id", "category_id", "click_count", "created_at", "deleted_at", "delivery_rate", "end_time", "id", "id_value", "image_url", "link_type", "max_age", "min_age", "push_mode", "push_scope", "scheduled_at", "send_count", "start_time", "status", "updated_at", "user_group"]
  end
end
