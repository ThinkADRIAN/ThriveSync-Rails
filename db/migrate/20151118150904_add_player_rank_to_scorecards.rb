class AddPlayerRankToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :player_rank, :integer
  end
end
