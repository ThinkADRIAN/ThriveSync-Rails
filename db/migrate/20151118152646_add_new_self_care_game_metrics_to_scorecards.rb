class AddNewSelfCareGameMetricsToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :self_care_base_value, :integer
    add_column :scorecards, :self_care_base_perk_register, :integer
    add_column :scorecards, :self_care_multiplier_perk_register, :integer
    add_column :scorecards, :self_care_streak_base_value, :integer
    add_column :scorecards, :self_care_streak_perk_register, :integer
  end
end
