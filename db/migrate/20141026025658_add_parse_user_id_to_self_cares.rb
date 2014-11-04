class AddParseUserIdToSelfCares < ActiveRecord::Migration
  def change
    add_column :self_cares, :parse_user_id, :string
  end
end
