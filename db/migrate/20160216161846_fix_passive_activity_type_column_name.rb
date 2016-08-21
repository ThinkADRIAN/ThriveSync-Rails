class FixPassiveActivityTypeColumnName < ActiveRecord::Migration
  def self.up
    rename_column :passive_activities, :type, :activity_type
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
