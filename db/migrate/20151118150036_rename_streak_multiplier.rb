class RenameStreakMultiplier < ActiveRecord::Migration
  def self.up
    rename_column :scorecards, :streak_multiplier, :multiplier
    rename_column :scorecards, :mood_streak_multiplier, :mood_multiplier
    rename_column :scorecards, :sleep_streak_multiplier, :sleep_multiplier
    rename_column :scorecards, :self_care_streak_multiplier, :self_care_multiplier
    rename_column :scorecards, :journal_streak_multiplier, :journal_multiplier
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
