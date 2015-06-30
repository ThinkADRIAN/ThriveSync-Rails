class SelfCareSerializer < ActiveModel::Serializer
  attributes :id, :counseling, :medication, :meditation, :exercise, :timestamp, :user_id
end
