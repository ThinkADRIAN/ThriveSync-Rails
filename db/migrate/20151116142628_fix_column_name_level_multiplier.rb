class FixColumnNameLevelMultiplier < ActiveRecord::Migration
  def self.up
    rename_column :scorecards, :level_multiplier, :streak_multiplier
    rename_column :scorecards, :mood_level_multiplier, :mood_streak_multiplier
    rename_column :scorecards, :sleep_level_multiplier, :sleep_streak_multiplier
    rename_column :scorecards, :self_care_level_multiplier, :self_care_streak_multiplier
    rename_column :scorecards, :journal_level_multiplier, :journal_streak_multiplier
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
