class AddClientsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :clients, :integer, array: true, default: []
  end
end