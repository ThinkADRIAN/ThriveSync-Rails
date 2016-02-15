class EffectiveTimeInterval < ActiveRecord::Base
  belongs_to :passive_data_point

  validates_presence_of :passive_data_point_id, :start_date_time, :end_date_time
end
