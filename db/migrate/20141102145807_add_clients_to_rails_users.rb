class AddClientsToRailsUsers < ActiveRecord::Migration
  def change
  	add_column :rails_users, :clients, :integer, array: true, default: []
  end
end