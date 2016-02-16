class EffectiveTimeIntervalSerializer < ActiveModel::Serializer
  attributes :id, :passive_data_point_id, :start_date_time, :end_date_time
end
