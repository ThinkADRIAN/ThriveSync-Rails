class AddParseUserIdToRailsUsers < ActiveRecord::Migration
  def change
    add_column :rails_users, :parse_user_id, :string
  end
end
