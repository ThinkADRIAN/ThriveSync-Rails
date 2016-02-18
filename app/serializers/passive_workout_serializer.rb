class PassiveWorkoutSerializer < ActiveModel::Serializer
  attributes :id, :passive_data_point_id, :workout_type, :kcal_burned_value, :kcal_burned_unit, :distance_value, :distance_unit, :duration_value, :duration_unit
end
