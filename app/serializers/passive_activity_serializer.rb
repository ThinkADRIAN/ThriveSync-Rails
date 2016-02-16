class PassiveActivitySerializer < ActiveModel::Serializer
  attributes :id, :passive_data_point_id, :type, :value, :unit, :kcal_burned_value, :kcal_burned_unit, :step_count
end
