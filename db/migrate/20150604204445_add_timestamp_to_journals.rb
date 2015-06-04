class AddTimestampToJournals < ActiveRecord::Migration
  def change
    add_column :journals, :timestamp, :datetime
  end
end
