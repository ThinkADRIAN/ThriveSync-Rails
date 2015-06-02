class AddSelfCareAttributesToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :self_care_checkin_count, :integer
    add_column :scorecards, :self_care_last_checkin_date, :timestamp
    add_column :scorecards, :self_care_streak_count, :integer
    add_column :scorecards, :self_care_streak_record, :integer
    add_column :scorecards, :self_care_level_multiplier, :integer
  end
end
