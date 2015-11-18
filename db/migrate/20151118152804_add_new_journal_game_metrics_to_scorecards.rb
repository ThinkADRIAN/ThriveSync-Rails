class AddNewJournalGameMetricsToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :journal_base_value, :integer
    add_column :scorecards, :journal_base_perk_register, :integer
    add_column :scorecards, :journal_multiplier_perk_register, :integer
    add_column :scorecards, :journal_streak_base_value, :integer
    add_column :scorecards, :journal_streak_perk_register, :integer
  end
end
