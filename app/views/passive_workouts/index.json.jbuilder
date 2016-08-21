json.array!(@passive_workouts) do |passive_workout|
  json.extract! passive_workout, :id, :passive_data_point_id, :workout_type, :kcal_burned_value, :kcal_burned_unit, :distance_value, :distance_unit
  json.url passive_workout_url(passive_workout, format: :json)
end
