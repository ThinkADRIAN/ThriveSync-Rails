class AddLastPerfectCheckinDateToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :last_perfect_checkin_date, :datetime
  end
end
