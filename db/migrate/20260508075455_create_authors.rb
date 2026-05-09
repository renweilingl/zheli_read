class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors, if_not_exists: true do |t|
      t.string :name, null: false, comment: '作者名'
      t.string :head_img, null: false, comment: '头像'

      t.timestamps
    end

    add_column :books, :author_id, :bigint
    add_column :books, :compilations, :bigint
  end
end
