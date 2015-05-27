class AddAuthenticationTokenToRailsUsers < ActiveRecord::Migration
  def change
    add_column :rails_users, :authentication_token, :string
    add_index :rails_users, :authentication_token
  end
end
