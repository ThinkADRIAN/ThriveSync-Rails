class AddJournalAttributesToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :journal_checkin_count, :integer
    add_column :scorecards, :journal_last_checkin_date, :integer
    add_column :scorecards, :journal_streak_count, :integer
    add_column :scorecards, :journal_streak_record, :integer
    add_column :scorecards, :journal_level_multiplier, :integer
  end
end
