json.array!(@reminders) do |reminder|
  json.extract! reminder, :id, :user_id, :message, :day_mask, :alert_time
  json.url reminder_url(reminder, format: :json)
end
