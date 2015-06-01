class AddLevelMultiplierToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :level_multiplier, :integer
  end
end
