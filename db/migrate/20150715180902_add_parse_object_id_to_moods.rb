class AddParseObjectIdToMoods < ActiveRecord::Migration
  def change
    add_column :moods, :parse_object_id, :string
  end
end
