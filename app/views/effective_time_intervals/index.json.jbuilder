json.array!(@effective_time_intervals) do |effective_time_interval|
  json.extract! effective_time_interval, :id, :passive_data_point_id, :start_date_time, :end_date_time
  json.url effective_time_interval_url(effective_time_interval, format: :json)
end
