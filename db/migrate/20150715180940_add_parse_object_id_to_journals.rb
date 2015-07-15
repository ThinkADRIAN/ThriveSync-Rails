class AddParseObjectIdToJournals < ActiveRecord::Migration
  def change
    add_column :journals, :parse_object_id, :string
  end
end
