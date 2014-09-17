class AddUserIdToSelfCares < ActiveRecord::Migration
  def change
    add_column :self_cares, :user_id, :integer
  end
end
