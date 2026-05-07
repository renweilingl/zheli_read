class AddBookLevelToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :book_level_id, :bigint
  end
end
