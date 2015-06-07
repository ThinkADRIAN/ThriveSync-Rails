class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :user_id
      t.boolean :completed_first_entry, :default => false
      t.boolean :completed_first_streak, :default => false
      t.boolean :rewards_enabled, :default => true

      t.timestamps
    end
  end
end
