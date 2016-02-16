json.array!(@passive_data_points) do |passive_data_point|
  json.extract! passive_data_point, :id, :user_id, :was_user_entered, :timezone, :source_uuid, :external_uuid, :creation_date_time, :schema_namespace, :schema_name, :schema_version, :effective_date_time
  json.url passive_data_point_url(passive_data_point, format: :json)
end
