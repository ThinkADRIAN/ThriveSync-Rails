class PassiveDataPointSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :was_user_entered, :timezone, :source_uuid, :external_uuid, :creation_date_time, :schema_namespace, :schema_name, :schema_version, :effective_date_time

  has_many :effective_time_intervals, include_nested_associations: true
  has_many :passive_sleeps, include_nested_associations: true
end