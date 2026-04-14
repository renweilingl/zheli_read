class CreateGrades < ActiveRecord::Migration[7.1]
  def change
    create_table :grades do |t|
      t.string :group_name, :limit => 8 
      t.string :name, :limit => 16
      t.timestamps
    end
  end
end
