class AddNewMoodGameMetricsToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :mood_base_value, :integer
    add_column :scorecards, :mood_base_perk_register, :integer
    add_column :scorecards, :mood_multiplier_perk_register, :integer
    add_column :scorecards, :mood_streak_base_value, :integer
    add_column :scorecards, :mood_streak_perk_register, :integer
  end
end
