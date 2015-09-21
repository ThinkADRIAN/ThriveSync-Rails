class AddSupportersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :supporters, :integer, array: true, default: []
  end
end
