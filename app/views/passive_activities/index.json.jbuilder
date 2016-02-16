json.array!(@passive_activities) do |passive_activity|
  json.extract! passive_activity, :id, :passive_data_point_id, :activity_type, :value, :unit, :kcal_burned_value, :kcal_burned_unit, :step_count
  json.url passive_activity_url(passive_activity, format: :json)
end
