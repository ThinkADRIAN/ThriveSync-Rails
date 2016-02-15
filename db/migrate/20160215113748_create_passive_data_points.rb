class CreatePassiveDataPoints < ActiveRecord::Migration
  def change
    create_table :passive_data_points do |t|
      t.string :user_id
      t.string :integer
      t.string :was_user_entered
      t.string :boolean
      t.string :timezone
      t.string :string
      t.string :source_uuid
      t.string :string
      t.string :external_uuid
      t.string :string
      t.string :creation_date_time
      t.string :date
      t.string :schema_namespace
      t.string :string
      t.string :schema_name
      t.string :string
      t.string :schema_version
      t.string :string

      t.timestamps
    end
  end
end
