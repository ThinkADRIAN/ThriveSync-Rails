class AddDaysSinceSignupToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :days_since_signup, :integer
  end
end
