class Content < ApplicationRecord
  # 文件类型枚举
  enum file_type: {
    epub: 'epub',       # 电子书
    pdf: 'pdf',         # PDF文档
    mp3: 'mp3',         # 音频
    mp4: 'mp4'          # 视频
  }

  # 文件类型显示名称
  FILE_TYPE_NAMES = {
    epub: '电子书',
    pdf: 'PDF文档',
    mp3: '音频',
    mp4: '视频'
  }.freeze

  # 文件类型图标
  FILE_TYPE_ICONS = {
    epub: 'layui-icon-read',
    pdf: 'layui-icon-file-b',
    mp3: 'layui-icon-headset',
    mp4: 'layui-icon-video'
  }.freeze

  # 文件类型颜色
  FILE_TYPE_COLORS = {
    epub: '#10b981',
    pdf: '#ef4444',
    mp3: '#8b5cf6',
    mp4: '#3b82f6'
  }.freeze

  # 允许的文件格式
  ALLOWED_FILE_TYPES = {
    epub: %w[epub],
    pdf: %w[pdf],
    mp3: %w[mp3],
    mp4: %w[mp4]
  }.freeze

  # 文件大小限制（字节）
  FILE_SIZE_LIMITS = {
    epub: 50.megabytes,
    pdf: 100.megabytes,
    mp3: 100.megabytes,
    mp4: 200.megabytes
  }.freeze

  # 验证规则
  validates :title, presence: true, length: { minimum: 1, maximum: 30 }
  validates :description, length: { maximum: 200 }, allow_blank: true

  # 标签验证
  validate :validate_tags

  # 文件验证
  validate :validate_file, if: :file_url_changed?

  # 回调
  before_validation :parse_tags

  # 作用域
  scope :by_file_type, ->(type) { where(file_type: type) }
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(view_count: :desc) }

  # 按文件类型筛选
  scope :filter_by_file_type, ->(type) {
    return all if type.blank?
    where(file_type: type)
  }

  # 获取文件类型显示名称
  def file_type_name
    FILE_TYPE_NAMES[file_type.to_sym] || file_type
  end

  # 获取文件类型图标
  def file_type_icon
    FILE_TYPE_ICONS[content_file_type.to_sym] || 'layui-icon-file'
  end

  # 获取文件类型颜色
  def file_type_color
    FILE_TYPE_COLORS[content_file_type.to_sym] || '#6b7280'
  end

  # 解析标签
  def tags_array
    return [] if tags.blank?

    begin
      JSON.parse(tags)
    rescue JSON::ParserError
      tags.split(',').map(&:strip).reject(&:empty?)
    end
  end

  # 设置标签
  def tags_array=(array)
    self.tags = array.reject(&:blank?).uniq.take(5).to_json
  end

  # 验证标签
  def validate_tags
    return if tags.blank?

    tags_list = tags_array
    if tags_list.length > 5
      errors.add(:tags, '最多只能添加5个标签')
    end

    tags_list.each do |tag|
      if tag.length > 5
        errors.add(:tags, '每个标签最多5个字')
        break
      end
    end
  end

  # 验证文件
  def validate_file
    return if file_url.blank?

    ext = file_url.split('.').last.downcase

    unless ALLOWED_FILE_TYPES.values.flatten.include?(ext)
      errors.add(:file_url, "不支持的文件格式：#{ext}")
      return
    end

    # 这里会在上传后验证文件大小
  end

  # 获取文件大小限制描述
  def self.file_size_limit_desc(type)
    size = FILE_SIZE_LIMITS[type.to_sym]
    return '无限制' unless size

    if size >= 1.gigabyte
      "#{(size / 1.gigabyte.to_f).round(1)} GB"
    elsif size >= 1.megabyte
      "#{(size / 1.megabyte.to_f).round(1)} MB"
    else
      "#{(size / 1.kilobyte.to_f).round(1)} KB"
    end
  end

  # 获取允许的文件格式列表
  def self.allowed_extensions
    ALLOWED_FILE_TYPES.values.flatten.uniq
  end

  # 获取文件大小描述
  def file_size_desc
    return '-' unless file_size

    if file_size >= 1.gigabyte
      "#{(file_size / 1.gigabyte.to_f).round(2)} GB"
    elsif file_size >= 1.megabyte
      "#{(file_size / 1.megabyte.to_f).round(2)} MB"
    elsif file_size >= 1.kilobyte
      "#{(file_size / 1.kilobyte.to_f).round(2)} KB"
    else
      "#{file_size} B"
    end
  end

  # 获取时长描述
  def duration_desc
    return '-' unless duration

    hours = duration / 3600
    minutes = (duration % 3600) / 60
    seconds = duration % 60

    if hours > 0
      format('%d:%02d:%02d', hours, minutes, seconds)
    else
      format('%d:%02d', minutes, seconds)
    end
  end

  private

  def parse_tags
    return if tags.is_a?(Array)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["copy_right", "created_at", "description", "duration", "file_name", "file_size", "file_type", "file_url", "grade_level", "id", "id_value", "second_level", "status", "tags", "third_level", "title", "updated_at"]
  end
end
