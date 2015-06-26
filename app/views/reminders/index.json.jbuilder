json.array!(@reminders) do |reminder|
  json.extract! reminder, :id, :user_id, :message, :sunday_enabled, :monday_enabled, :tuesday_enabled, :wednesday_enabled, :thursday_enabled, :friday_enabled, :saturday_enabled, :alert_time
  json.url reminder_url(reminder, format: :json)
end
