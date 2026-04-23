# frozen_string_literal: true

class Chapter < ApplicationRecord
  belongs_to :book

  # 内容文件类型
  FILE_TYPES = {
    epub: 'epub',
    pdf: 'pdf',
    mp3: 'mp3',
    mp4: 'mp4'
  }.freeze

  FILE_TYPE_NAMES = {
    epub: 'EPUB电子书',
    pdf: 'PDF文档',
    mp3: '有声',
    mp4: '视频'
  }.freeze

  # 验证
  validates :name, presence: true, length: { maximum: 100 }
  validates :chapter_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :chapter_number, uniqueness: { scope: :book_id }
  validates :content_file_type, inclusion: { in: FILE_TYPES.values }, allow_blank: true

  # 排序
  default_scope { order(:sort_order, :chapter_number) }

  # 类方法
  class << self
    def search(keyword)
      return all if keyword.blank?

      where('name LIKE ?', "%#{keyword}%")
    end

    def published
      where(is_published: true)
    end

    def free
      where(is_free: true)
    end

    def next_chapter_number(book_id)
      max = where(book_id: book_id).maximum(:chapter_number)
      max.present? ? max + 1 : 1
    end
  end

  # 实例方法
  def file_type_name
    FILE_TYPE_NAMES[content_file_type.to_sym] || content_file_type
  end

  def content_file_size_formatted
    return '-' if content_file_size.blank?

    if content_file_size < 1024
      "#{content_file_size} B"
    elsif content_file_size < 1024 * 1024
      "#{(content_file_size / 1024.0).round(2)} KB"
    else
      "#{(content_file_size / 1024.0 / 1024.0).round(2)} MB"
    end
  end

  # 发布
  def publish!
    update(is_published: true)
  end

  # 下线
  def unpublish!
    update(is_published: false)
  end

  # 切换发布状态
  def toggle_publish
    if is_published?
      unpublish!
      '已下线'
    else
      publish!
      '已上线'
    end
  end

  # 切换免费状态
  def toggle_free
    update(is_free: !is_free)
    is_free? ? '已设为免费' : '已设为付费'
  end

  # 移动章节
  def move_to(new_position)
    return false if new_position < 1

    ActiveRecord::Base.transaction do
      if new_position > chapter_number
        # 向下移动
        book.book_chapters
            .where('chapter_number > ? AND chapter_number <= ?', chapter_number, new_position)
            .update_all('chapter_number = chapter_number - 1')
      elsif new_position < chapter_number
        # 向上移动
        book.book_chapters
            .where('chapter_number >= ? AND chapter_number < ?', new_position, chapter_number)
            .update_all('chapter_number = chapter_number + 1')
      end
      update(chapter_number: new_position, sort_order: new_position)
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
