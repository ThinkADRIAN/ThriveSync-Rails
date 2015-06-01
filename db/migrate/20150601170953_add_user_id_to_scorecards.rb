class AddUserIdToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :user_id, :integer
  end
end
