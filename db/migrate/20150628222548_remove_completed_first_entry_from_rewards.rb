class RemoveCompletedFirstEntryFromRewards < ActiveRecord::Migration
  def change
    remove_column :rewards, :completed_first_entry, :boolean
  end
end
