class PassiveDataPointSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :was_user_entered, :timezone, :source_uuid, :external_uuid, :creation_date_time, :schema_namespace, :schema_name, :schema_version
end