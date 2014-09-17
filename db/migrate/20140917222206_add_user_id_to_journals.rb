class AddUserIdToJournals < ActiveRecord::Migration
  def change
    add_column :journals, :user_id, :integer
  end
end
