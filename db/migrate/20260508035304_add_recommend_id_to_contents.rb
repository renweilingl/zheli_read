class AddRecommendIdToContents < ActiveRecord::Migration[7.1]
  def change
    add_column :contents, :recommend_id, :bigint
    add_column :contents, :author_id, :bigint
  end
end
