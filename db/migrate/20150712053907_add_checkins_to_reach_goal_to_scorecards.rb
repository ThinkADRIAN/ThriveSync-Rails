class AddCheckinsToReachGoalToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :checkins_to_reach_goal, :integer
  end
end
