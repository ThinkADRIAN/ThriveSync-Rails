json.array!(@passive_sleeps) do |passive_sleep|
  json.extract! passive_sleep, :id, :passive_data_point_id, :category_type, :category_value, :value, :unit
  json.url passive_sleep_url(passive_sleep, format: :json)
end
