class AddParseUserIdToMoods < ActiveRecord::Migration
  def change
    add_column :moods, :parse_user_id, :string
  end
end
