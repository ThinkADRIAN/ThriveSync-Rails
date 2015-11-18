class AddPerkMetricsToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :player_perk_trigger, :integer
    add_column :scorecards, :player_perks_earned, :integer
  end
end
