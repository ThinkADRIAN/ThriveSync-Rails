class AddParseUserIdToSleeps < ActiveRecord::Migration
  def change
    add_column :sleeps, :parse_user_id, :string
  end
end
