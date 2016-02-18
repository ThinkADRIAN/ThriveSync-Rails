class PassiveDataPoint < ActiveRecord::Base
  belongs_to :user
  has_many :effective_time_intervals, :dependent => :destroy
  has_many :passive_sleeps, :dependent => :destroy
  has_many :passive_activities, :dependent => :destroy
  has_many :passive_workouts, :dependent => :destroy

  accepts_nested_attributes_for :effective_time_intervals, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :passive_sleeps, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :passive_activities, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :passive_workouts, reject_if: :all_blank, allow_destroy: true

  #validates_presence_of :source_uuid, :creation_date_time, :schema_namespace, :schema_name, :schema_version
end
