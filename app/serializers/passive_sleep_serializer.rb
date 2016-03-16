class PassiveSleepSerializer < ActiveModel::Serializer
  attributes :id, :passive_data_point_id, :category_type, :category_value, :value, :unit
end
