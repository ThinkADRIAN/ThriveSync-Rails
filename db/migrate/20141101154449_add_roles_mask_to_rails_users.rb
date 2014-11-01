class AddRolesMaskToRailsUsers < ActiveRecord::Migration
  def change
    add_column :rails_users, :roles_mask, :integer
  end
end
