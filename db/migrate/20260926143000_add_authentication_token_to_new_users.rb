class AddAuthenticationTokenToNewUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :new_users, :authentication_token, :string
    add_column :new_users, :token_last_used_at, :datetime
    add_index :new_users, :authentication_token, unique: true
  end
end
