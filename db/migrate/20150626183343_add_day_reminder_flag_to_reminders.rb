class AddDayReminderFlagToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :sunday_enabled, :boolean
    add_column :reminders, :monday_enabled, :boolean
    add_column :reminders, :tuesday_enabled, :boolean
    add_column :reminders, :wednesday_enabled, :boolean
    add_column :reminders, :thursday_enabled, :boolean
    add_column :reminders, :friday_enabled, :boolean
    add_column :reminders, :saturday_enabled, :boolean
  end
end
