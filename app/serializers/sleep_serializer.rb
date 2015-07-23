class SleepSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :finish_time, :quality, :time, :created_at, :updated_at, :user_id
end
