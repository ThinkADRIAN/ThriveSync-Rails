class AddCheckinFlagsToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :checkin_sunday, :boolean
    add_column :scorecards, :checkin_monday, :boolean
    add_column :scorecards, :checkin_tuesday, :boolean
    add_column :scorecards, :checkin_wednesday, :boolean
    add_column :scorecards, :checkin_thursday, :boolean
    add_column :scorecards, :checkin_friday, :boolean
    add_column :scorecards, :checkin_saturday, :boolean
  end
end
