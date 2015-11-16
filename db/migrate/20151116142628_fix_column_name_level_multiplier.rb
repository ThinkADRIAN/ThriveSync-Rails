class FixColumnNameLevelMultiplier < ActiveRecord::Migration
  def self.up
    rename_column :scorecards, :level_multiplier, :streak_multiplier
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
