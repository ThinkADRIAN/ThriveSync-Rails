class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :user_id
      t.boolean :completed_first_entry
      t.boolean :completed_first_streak
      t.boolean :rewards_enabled

      t.timestamps
    end
  end
end
