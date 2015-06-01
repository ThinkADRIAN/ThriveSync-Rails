class CreateScorecards < ActiveRecord::Migration
  def change
    create_table :scorecards do |t|
      t.integer :checkin_count
      t.integer :perfect_checkin_count
      t.datetime :last_checkin_date
      t.integer :streak_count
      t.integer :streak_record
      t.integer :moods_score
      t.integer :sleeps_score
      t.integer :self_cares_score
      t.integer :journals_score

      t.timestamps
    end
  end
end
