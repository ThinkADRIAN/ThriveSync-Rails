json.array!(@passive_data_points) do |passive_data_point|
  json.extract! passive_data_point, :id, :user_id, :integer, :was_user_entered, :boolean, :timezone, :string, :source_uuid, :string, :external_uuid, :string, :creation_date_time, :date, :schema_namespace, :string, :schema_name, :string, :schema_version, :string
  json.url passive_data_point_url(passive_data_point, format: :json)
end
