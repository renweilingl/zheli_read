class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      # 基本信息
      t.string :title, null: false, comment: '标题'
      t.text :description, comment: '简介'
      t.string :tags, comment: '标签（JSON格式）'

      # 分类关联
      t.string :grade_level, comment: '一级分类'
      t.string :second_level, comment: '二级分类'
      t.string :third_level, comment: '三级分类'

      # 文件信息
      t.string :file_type, comment: '文件类型：epub/pdf/mp3/mp4'
      t.string :file_url, comment: '文件URL'
      t.string :file_name, comment: '原始文件名'
      t.integer :file_size, comment: '文件大小（字节）'
      t.integer :duration, comment: '时长（秒）- 音视频'

      t.text :copy_right, comment: '版权信息'
      t.string :cover_img, comment: '封面'
      t.boolean :status, default: true

      t.timestamps
    end

    # 添加索引
    add_index :contents, :grade_level
    add_index :contents, :title
    add_index :contents, :file_type
  end
end
