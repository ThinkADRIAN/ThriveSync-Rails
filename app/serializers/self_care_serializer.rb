class SelfCareSerializer < ActiveModel::Serializer
  attributes :id, :counseling, :medication, :meditation, :exercise, :timestamp, :created_at, :updated_at, :user_id
end
