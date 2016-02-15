class PassiveDataPointSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :integer, :was_user_entered, :boolean, :timezone, :string, :source_uuid, :string, :external_uuid, :string, :creation_date_time, :date, :schema_namespace, :string, :schema_name, :string, :schema_version, :string
end
