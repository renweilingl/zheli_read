# frozen_string_literal: true

class PushNotification < ApplicationRecord
  # 推送类型
  enum :push_type, {
    system_notification: 0,
    activity_notification: 1
  }, prefix: true

  # 推送范围
  enum :push_scope, {
    all_users: 0,
    age_range: 1,
    specific_users: 2
  }, prefix: true

  # 状态
  enum :status, {
    draft: 0,
    scheduled: 1,
    sending: 2,
    sent: 3,
    partial: 4,
    failed: 5
  }, prefix: true

  # 验证
  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 50 }
  validates :push_type, presence: true
  validates :push_scope, presence: true
  validates :link_url, format: { with: /\Ahttps?:\/\/.+\z/, message: '格式不正确，请以 http:// 或 https:// 开头' }, allow_blank: true
  validates :min_age, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :max_age, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :scheduled_at_cannot_be_in_past, if: :scheduled?

  # 作用域
  scope :sorted, -> { order(created_at: :desc) }
  scope :recent, -> { where('created_at > ?', 7.days.ago) }

  # 回调
  before_save :set_status_defaults

  # 统计方法
  def delivery_rate_percentage
    return 0 if send_count.nil? || send_count.zero?
    ((click_count.to_f / send_count.to_f) * 100).round(1)
  end

  def scope_display
    case push_scope
    when 'all_users' then '全部用户'
    when 'age_range' then "#{min_age}~#{max_age}岁"
    when 'specific_users' then '指定用户群体'
    end
  end

  def push_type_display
    case push_type
    when 'system_notification' then '系统通知'
    when 'activity_notification' then '活动通知'
    end
  end

  def status_display
    case status
    when 'draft' then '草稿'
    when 'scheduled' then '待发送'
    when 'sending' then '发送中'
    when 'sent' then '已发送'
    when 'partial' then '部分送达'
    when 'failed' then '发送失败'
    end
  end

  private

  def scheduled_at_cannot_be_in_past
    return if scheduled_at.blank?
    errors.add(:scheduled_at, '定时时间不能早于当前时间') if scheduled_at < Time.current
  end

  def set_status_defaults
    self.status ||= :draft
  end
end
