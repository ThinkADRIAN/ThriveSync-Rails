class FixPassiveDataIdColumnName < ActiveRecord::Migration
  def self.up
    rename_column :passive_sleeps, :passive_data_id, :passive_data_point_id
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
