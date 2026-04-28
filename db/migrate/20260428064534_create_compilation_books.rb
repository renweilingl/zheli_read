class CreateCompilationBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :compilation_books do |t|
      t.references :compilation, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end

    add_index :compilation_books, [:compilation_id, :book_id], unique: true
  end
end
