class AddTimestampToSelfCares < ActiveRecord::Migration
  def change
    add_column :self_cares, :timestamp, :datetime
  end
end
