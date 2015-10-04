class AddParseObjectIdToSelfCares < ActiveRecord::Migration
  def change
    add_column :self_cares, :parse_object_id, :string
  end
end
