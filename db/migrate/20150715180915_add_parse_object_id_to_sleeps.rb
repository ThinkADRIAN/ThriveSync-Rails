class AddParseObjectIdToSleeps < ActiveRecord::Migration
  def change
    add_column :sleeps, :parse_object_id, :string
  end
end
