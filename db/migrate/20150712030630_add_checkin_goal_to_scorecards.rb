class AddCheckinGoalToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :checkin_goal, :integer
  end
end
