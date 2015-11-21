class AddThriversToUsers < ActiveRecord::Migration
  def change
    add_column :users, :thrivers, :integer, array: true, default: []
  end
end
