class CreateSuppliers < ActiveRecord::Migration[7.1]
  def change
    create_table :suppliers do |t|
      t.string :name, null: false, comment: '供应商名称'
      t.timestamps
    end

    add_index :suppliers, :name
  end
end
