class AddSleepAttributesToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :sleep_checkin_count, :integer
    add_column :scorecards, :sleep_last_checkin_date, :integer
    add_column :scorecards, :sleep_streak_count, :integer
    add_column :scorecards, :sleep_streak_record, :integer
    add_column :scorecards, :sleep_level_multiplier, :integer
  end
end
