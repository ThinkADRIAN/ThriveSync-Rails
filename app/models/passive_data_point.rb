class PassiveDataPoint < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :source_uuid, :creation_date_time, :schema_namespace, :schema_name, :schema_version
end
