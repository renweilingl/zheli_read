class SorceryRememberMe < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :remember_me_token, :string, default: nil
    add_column :users, :remember_me_token_expires_at, :datetime, default: nil

    add_index :users, :remember_me_token

    add_column :users, :role, :string, default: 'editor', null: false, after: :salt
    add_index :users, :role
  end
end
