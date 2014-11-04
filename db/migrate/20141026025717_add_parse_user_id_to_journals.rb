class AddParseUserIdToJournals < ActiveRecord::Migration
  def change
    add_column :journals, :parse_user_id, :string
  end
end
