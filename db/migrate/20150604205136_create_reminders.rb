class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :user_id
      t.string :message
      t.string :day_mask
      t.datetime :alert_time

      t.timestamps
    end
  end
end
