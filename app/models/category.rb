class Category < ApplicationRecord
  # 验证规则
  validates :name, presence: true, length: { maximum: 100 }
  validates :level, presence: true, inclusion: { in: 1..4 }
  validates :sn, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  

  # 作用域
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :by_level, ->(level) { where(level: level) }
  scope :recommended, -> { where(level: 4) }
  scope :sorted, -> { order(sn: :asc, created_at: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  # 一级分类（年级）
  scope :grade_levels, -> { by_level(1) }

  # 二级分类
  scope :second_level, -> { by_level(2) }

  # 三级分类
  scope :third_level, -> { by_level(3) }

  # 分类级别常量
  LEVEL_GRADE = 1       # 一级分类（年级）
  LEVEL_SECOND = 2      # 二级分类
  LEVEL_THIRD = 3       # 三级分类
  LEVEL_RECOMMENDED = 4 # 推荐分类

  # 获取级别信息
  def level_info
    LEVEL_TYPES[level] || {}
  end

  # 获取级别名称
  def level_name
    level_info[:name] || "未知级别"
  end

  # 获取级别代码
  def level_code
    level_info[:code]
  end

  # 获取级别图标
  def level_icon
    level_info[:icon] || '📁'
  end

  # 获取级别颜色
  def level_color
    level_info[:color] || '#6b7280'
  end

  # 获取级别描述
  def level_description
    level_info[:description] || ''
  end

  # 级别判断方法
  def grade_level?
    level == LEVEL_GRADE
  end

  def second_level?
    level == LEVEL_SECOND
  end

  def third_level?
    level == LEVEL_THIRD
  end

  def can_destroy?
    true
  end

  def can_edit?
    true
  end

  def self.generate_code(base_code)
    base_code = base_code.parameterize.underscore[0..40]
    code = base_code
    counter = 1

    while exists?(code: code)
      code = "#{base_code}_#{counter}"
      counter += 1
    end

    code
  end

  # 获取一级分类选项（年级）
  def self.grade_options
    grade_levels.active.sorted.map { |g| [g.name, g.id] }
  end

  # 获取推荐分类选项
  def self.recommended_options
    recommended.active.sorted.map { |r| [r.name, r.id] }
  end

  # 获取二级分类选项
  def self.second_level_options
    second_level.active.sorted.map { |s| [s.name, s.id] }
  end

  # 获取三级分类选项
  def self.third_level_options
    third_level.active.sorted.map { |t| [t.name, t.id] }
  end

  # 获取分类统计信息
  def self.statistics(category = nil)
    if category
      # 返回指定分类的同级统计信息
      level_categories = by_level(category.level)
      {
        total: level_categories.count,
        active: level_categories.active.count
      }
    else
      # 返回全局统计信息
      {
        total: count,
        active: active.count,
        inactive: inactive.count,
        grade_levels: grade_levels.count,
        second_level: second_level.count,
        third_level: third_level.count,
        recommended: recommended.count
      }
    end
  end

  # 导出为 JSON
  def to_json(*args)
    super(*args).merge(
      level_name: level_name,
      level_icon: level_icon,
      level_color: level_color,
      level_description: level_description
    )
  end

  def self.ransackable_attributes(auth_object = nil)
    ["active", "created_at", "description", "id", "id_value", "is_recommended", "level", "name", "sn", "updated_at"]
  end
end
