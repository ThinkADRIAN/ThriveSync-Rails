class AddTimeToSleeps < ActiveRecord::Migration
  def change
    add_column :sleeps, :time, :integer
  end
end
