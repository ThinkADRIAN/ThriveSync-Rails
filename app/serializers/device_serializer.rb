class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :enabled, :token, :platform, :created_at, :updated_at, :user_id
end
