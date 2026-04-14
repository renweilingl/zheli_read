class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false              # 分类名称
      t.integer :level, null: false, default: 1            # 分类级别（1:一级/年级, 2:二级, 3:三级）
      t.boolean :is_recommended, default: false # 是否为推荐分类
      t.integer :sn, default: 0        # 排序
      t.text :description                      # 描述
      t.boolean :active, default: true         # 是否启用

      t.timestamps
    end

    add_index :categories, :level
    add_index :categories, :is_recommended
  end
end
