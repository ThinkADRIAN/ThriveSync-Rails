class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :user_id
      t.string :message
      t.time :alert_time

      t.timestamps
    end
  end
end
