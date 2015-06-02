class AddTotalScoreToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :total_score, :integer
  end
end
