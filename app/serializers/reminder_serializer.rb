class ReminderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :message, :day_mask, :alert_time
end
