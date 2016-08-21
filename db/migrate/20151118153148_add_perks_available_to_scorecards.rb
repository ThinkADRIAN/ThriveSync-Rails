class AddPerksAvailableToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :player_perks_available, :integer
  end
end
