class AddMoodAttributesToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :mood_checkin_count, :integer
    add_column :scorecards, :mood_last_checkin_date, :integer
    add_column :scorecards, :mood_streak_count, :integer
    add_column :scorecards, :mood_streak_record, :integer
    add_column :scorecards, :mood_level_multiplier, :integer
  end
end
