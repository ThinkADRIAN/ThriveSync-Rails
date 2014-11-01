class AddNamesToRailsUsers < ActiveRecord::Migration
  def change
    add_column :rails_users, :first_name, :string
    add_column :rails_users, :last_name, :string
  end
end
