class PassiveDataPoint < ActiveRecord::Base
  belongs_to :user
  has_many :effective_time_intervals

  accepts_nested_attributes_for :effective_time_intervals

  validates_presence_of :source_uuid, :creation_date_time, :schema_namespace, :schema_name, :schema_version, :effective_date_time
end
