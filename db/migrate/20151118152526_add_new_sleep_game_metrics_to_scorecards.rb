class AddNewSleepGameMetricsToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :sleep_base_value, :integer
    add_column :scorecards, :sleep_base_perk_register, :integer
    add_column :scorecards, :sleep_multiplier_perk_register, :integer
    add_column :scorecards, :sleep_streak_base_value, :integer
    add_column :scorecards, :sleep_streak_perk_register, :integer
  end
end
