class RemoveCompletedFirstStreakFromRewards < ActiveRecord::Migration
  def change
    remove_column :rewards, :completed_first_streak, :boolean
  end
end
